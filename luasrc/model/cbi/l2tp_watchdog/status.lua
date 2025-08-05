-- Copyright 2025 VPN Watchdog
-- Licensed to the public under the Apache License 2.0.

local util = require "luci.util"
local sys = require "luci.sys"
local fs = require "nixio.fs"

local m = Map("l2tp-watchdog", translate("VPN看门狗 - 状态"), translate("查看 VPN 看门狗运行状态和日志"))

-- Status section
local s = m:section(NamedSection, "config", "l2tp-watchdog", translate("运行状态"))

-- Script status
local script_status = s:option(DummyValue, "_script_status", translate("脚本状态"))
function script_status.cfgvalue(self, section)
    local running = sys.call("pgrep -f '/etc/l2tp-watchdog/vpn-watchdog' >/dev/null 2>&1") == 0
    if running then
        return '<span style="color: green;">' .. translate("运行中") .. '</span>'
    else
        return '<span style="color: red;">' .. translate("已停止") .. '</span>'
    end
end

-- VPN connection status
local vpn_status = s:option(DummyValue, "_vpn_status", translate("VPN 连接状态"))
function vpn_status.cfgvalue(self, section)
    local interface = luci.model.uci.cursor():get("l2tp-watchdog", "config", "interface") or "VPN"
    local status_cmd = string.format("ubus call network.interface.%s status 2>/dev/null | grep '\"up\": true' >/dev/null 2>&1", interface)
    local connected = sys.call(status_cmd) == 0
    if connected then
        return '<span style="color: green;">' .. translate("已连接") .. '</span>'
    else
        return '<span style="color: red;">' .. translate("未连接") .. '</span>'
    end
end

-- Internet connectivity status
local internet_status = s:option(DummyValue, "_internet_status", translate("外网连通性"))
function internet_status.cfgvalue(self, section)
    local test_ip = luci.model.uci.cursor():get("l2tp-watchdog", "config", "test_ip") or "223.5.5.5"
    local ping_cmd = string.format("ping -c 1 -W 5 %s >/dev/null 2>&1", test_ip)
    local connected = sys.call(ping_cmd) == 0
    if connected then
        return '<span style="color: green;">' .. translate("正常") .. '</span>'
    else
        return '<span style="color: red;">' .. translate("断开") .. '</span>'
    end
end

-- Log section
local log_section = m:section(TypedSection, "_log", translate("运行日志"))
log_section.template = "cbi/tblsection"
log_section.anonymous = true
log_section.readonly = true

local log_text = log_section:option(TextValue, "_log_text")
log_text.template = "cbi/tvalue"
log_text.rows = 20
log_text.readonly = true

function log_text.cfgvalue(self, section)
    local log_lines = util.exec("logread -e l2tp_watchdog | tail -n 50 2>/dev/null")
    if log_lines == "" then
        return translate("暂无日志")
    end
    return log_lines
end

return m
