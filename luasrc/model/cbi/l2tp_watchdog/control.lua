-- Copyright 2025 VPN Watchdog
-- Licensed to the public under the Apache License 2.0.

local util = require "luci.util"
local sys = require "luci.sys"
local fs = require "nixio.fs"

local m = Map("l2tp-watchdog", translate("VPN看门狗 - 控制"), translate("控制 VPN 看门狗脚本的启动和停止"))

-- Control section
local s = m:section(NamedSection, "config", "l2tp-watchdog", translate("服务控制"))

-- Script control
local control = s:option(Button, "_control", translate("脚本控制"))
control.inputtitle = translate("启动")
control.inputstyle = "apply"

function control.write(self, section)
    -- Start the script
    sys.call("/etc/init.d/l2tp-watchdog start >/dev/null 2>&1")
    -- Enable auto-start
    sys.call("/etc/init.d/l2tp-watchdog enable >/dev/null 2>&1")
end

function control.cfgvalue(self, section)
    local running = sys.call("pgrep -f '/etc/l2tp-watchdog/vpn-watchdog' >/dev/null 2>&1") == 0
    if running then
        self.inputtitle = translate("重启")
        self.inputstyle = "reload"
    else
        self.inputtitle = translate("启动")
        self.inputstyle = "apply"
    end
    return true
end

-- Stop button
local stop = s:option(Button, "_stop", translate("停止脚本"))
stop.inputtitle = translate("停止")
stop.inputstyle = "remove"

function stop.write(self, section)
    -- Stop the script
    sys.call("/etc/init.d/l2tp-watchdog stop >/dev/null 2>&1")
    -- Disable auto-start
    sys.call("/etc/init.d/l2tp-watchdog disable >/dev/null 2>&1")
end

return m
