fluent-plugin-tail-labeled-tsv
==============================

a plugin to tail a labeled tsv log file for fluentd.

Configuration
=============

```
<source>
  type tail_labeled_tsv
  path /var/log/nginx/access_log.tsv
  tag access_log
  pos_file /tmp/fluent.log.pos
</source>
```

License
=========

* Apache License, Version 2.0
