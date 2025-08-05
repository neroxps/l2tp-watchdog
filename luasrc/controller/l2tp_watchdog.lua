-- Copyright 2025 VPN Watchdog
-- Licensed to the public under the Apache License 2.0.

module("luci.controller.l2tp_watchdog", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/l2tp-watchdog") then
		return
	end

	local page

	page = entry({"admin", "services", "l2tp_watchdog"}, alias("admin", "services", "l2tp_watchdog", "config"), _("VPN看门狗"), 60)
	page.dependent = true
	page.acl_depends = { "luci-app-l2tp-watchdog" }

	entry({"admin", "services", "l2tp_watchdog", "config"}, cbi("l2tp_watchdog/config"), _("配置"), 10).leaf = true
	entry({"admin", "services", "l2tp_watchdog", "status"}, call("action_status"), _("状态"), 20).leaf = true
	entry({"admin", "services", "l2tp_watchdog", "log"}, call("action_log"), _("日志"), 30).leaf = true
	entry({"admin", "services", "l2tp_watchdog", "run"}, call("action_run")).leaf = true
end

function action_status()
	local sys = require "luci.sys"
	local util = require "luci.util"
	local uci = require "luci.model.uci".cursor()
	
	local status = {
		running = false,
		vpn_status = "unknown",
		wan_status = "unknown"
	}
	
	-- Check if script is running
	status.running = sys.call("pgrep -f '/etc/l2tp-watchdog/vpn-watchdog' >/dev/null") == 0
	
	-- Get config values
	local interface = uci:get("l2tp-watchdog", "config", "interface") or "VPN"
	local gateway = uci:get("l2tp-watchdog", "config", "gateway") or "10.2.0.1"
	local test_ip = uci:get("l2tp-watchdog", "config", "test_ip") or "223.5.5.5"
	
	-- Check VPN status
	if sys.call("ubus call network.interface.%s status | grep -q '\"up\": true'" % interface) == 0 then
		status.vpn_status = "up"
		-- Check gateway connectivity
		if sys.call("ping -c 1 -W 5 %s >/dev/null 2>&1" % gateway) == 0 then
			status.vpn_status = "connected"
		end
	else
		status.vpn_status = "down"
	end
	
	-- Check WAN status
	if sys.call("ping -c 1 -W 5 %s >/dev/null 2>&1" % test_ip) == 0 then
		status.wan_status = "connected"
	else
		status.wan_status = "disconnected"
	end
	
	luci.http.prepare_content("application/json")
	luci.http.write_json(status)
end

function action_run()
	local util = require "luci.util"
	local fs = require "nixio.fs"
	
	local running = luci.http.formvalue("running")
	
	if running == "1" then
		-- Start the script
		util.exec("/etc/init.d/l2tp-watchdog start")
		util.exec("/etc/init.d/l2tp-watchdog enable")
	else
		-- Stop the script
		util.exec("/etc/init.d/l2tp-watchdog stop")
		util.exec("/etc/init.d/l2tp-watchdog disable")
	end
	
	luci.http.prepare_content("application/json")
	luci.http.write_json({success = true})
end

function action_log()
	local util = require "luci.util"
	local sys = require "luci.sys"
	
	-- Get log content
	local log_lines = util.trim(sys.exec("logread -e l2tp_watchdog | tail -n 100"))
	if log_lines == "" then
		log_lines = translate("暂无日志")
	end
	
	-- Render the view template with log content
	luci.template.render("l2tp_watchdog/log", {log_content = log_lines})
end
