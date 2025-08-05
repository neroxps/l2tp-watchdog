-- Copyright 2025 VPN Watchdog
-- Licensed to the public under the Apache License 2.0.

local m = Map("l2tp-watchdog", translate("VPN看门狗 - 配置"), translate("配置 VPN 看门狗参数"))

local s = m:section(NamedSection, "config", "l2tp-watchdog", translate("基本设置"))

s:option(Value, "interface", translate("VPN 接口名称"), translate("VPN 接口的逻辑名称")).default = "VPN"
s:option(Value, "gateway", translate("VPN 网关"), translate("VPN 网关 IP 地址")).default = "10.2.0.1"
s:option(Value, "test_ip", translate("外网测试 IP"), translate("用于测试外网连通性的 IP 地址")).default = "223.5.5.5"
s:option(Value, "check_interval", translate("检查间隔"), translate("常规检查间隔（秒）")).default = "5"
s:option(Value, "initial_delay", translate("初始延迟"), translate("系统启动后延迟执行时间（秒）")).default = "120"
s:option(Value, "max_retries", translate("最大重试次数"), translate("连接失败后的最大重试次数")).default = "5"
s:option(Value, "retry_delay", translate("重试延迟"), translate("重试间隔（秒）")).default = "10"
s:option(Value, "conn_timeout", translate("连接超时"), translate("VPN 连接建立超时时间（秒）")).default = "30"

return m
