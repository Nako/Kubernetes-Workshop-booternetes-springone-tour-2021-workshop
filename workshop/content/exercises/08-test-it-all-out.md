
### Go Time

> Note: Please, wait for a few seconds until all the setup from the previous step is complete otherwise the following commands could fail until setup completes.

Let's test it all out. First with `curl`.

```execute-2
curl gateway-{{ session_namespace }}.{{ ingress_domain }}/cos | jq -r
```

Now lets try it in the browser:

```dashboard:open-url
url: http://gateway-{{ session_namespace }}.{{ ingress_domain }}/cos
```

