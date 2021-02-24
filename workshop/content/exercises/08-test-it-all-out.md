
### Go Time

Let's test it all out. First with `curl`.

```execute-2
curl lgateway-{{ session_namespace }}.{{ ingress_domain }}/cos | jq -r
```

Now lets try it in the browser:

```dashboard:open-url
url: https://gateway-{{ session_namespace }}.{{ ingress_domain }}/cos
```

