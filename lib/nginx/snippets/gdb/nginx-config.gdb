set $cd = ngx_cycle->config_dump
set $nelts = $cd.nelts
set $elts = (ngx_conf_dump_t*)($cd.elts)
while ($nelts-- > 0)
  set $name = $elts[$nelts]->name.data
  printf "Dumping %s to nginx.conf.running\n", $name
append memory nginx.conf.running \
  $elts[$nelts]->buffer.start $elts[$nelts]->buffer.end
end
