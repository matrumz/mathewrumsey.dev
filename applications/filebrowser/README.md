#todo

Sample user import file:

```yaml
- username: admin
  password: "$2a$10$zvUuP.MdJH3CbD7aVoHVaeR5i5OVLTZHDi5mfZn7WPTtoCD6b91hO"
  scope: /
  perm:
    admin: true
    execute: true
    create: true
    rename: true
    modify: true
    delete: true
    share: true
    download: true

- username: demo
  password: "$2a$10$QoYo0OXsU4ti1gv/k2oK.eTHLCkJ0LiWEflfIh9IiCuQbDOp9sLRq"
  scope: /
  lockPassword: true
  perm:
    admin: false
    execute: false
    create: false
    rename: false
    modify: false
    delete: false
    share: false
    download: true
```
