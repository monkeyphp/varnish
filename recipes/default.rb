#
# Cookbook Name:: varnish
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

remote_file "#{Chef::Config[:file_cache_path]}/varnish-libs-4.0.0-1.el6.x86_64.rpm" do
    source "http://repo.varnish-cache.org/redhat/varnish-4.0/el6/x86_64/varnish/varnish-libs-4.0.0-1.el6.x86_64.rpm"
    mode "0777"
    action :create_if_missing
    backup false
end

package "varnish-libs" do
    source "#{Chef::Config[:file_cache_path]}/varnish-libs-4.0.0-1.el6.x86_64.rpm"
    provider Chef::Provider::Package::Rpm
    action :install
end

package "jemalloc" do
    action :install
end

remote_file "#{Chef::Config[:file_cache_path]}/varnish-4.0.0-1.el6.x86_64.rpm" do
    source "http://repo.varnish-cache.org/redhat/varnish-4.0/el6/x86_64/varnish/varnish-4.0.0-1.el6.x86_64.rpm"
    mode "0777"
    action :create_if_missing
    backup false
end

package "varnish" do
    source "#{Chef::Config[:file_cache_path]}/varnish-4.0.0-1.el6.x86_64.rpm"
    provider Chef::Provider::Package::Rpm
    action :install     
end

service "varnish" do
    supports :start => true, :stop => true, :status => true, :restart => true, :reload => true
    action :nothing
end

template "/etc/varnish/default.vcl" do 
    source   "default.vcl.erb"
    owner    "root"
    group    "root"
    mode     0644
end

template "/etc/sysconfig/varnish" do
    source   "varnish.erb"
    owner    "root"
    group    "root"
    mode     0644
    notifies :start, resources(:service => "varnish") 
end
