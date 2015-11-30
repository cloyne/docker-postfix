Image extending [tozd/postfix](https://github.com/tozd/docker-postfix) image to integrate
it with [tozd/sympa](https://github.com/tozd/docker-sympa) mailing lists service.

**It contains hard-coded values used at the [Cloyne](http://cloyne.org/) deployment.**

The intended use of this image is that it is run alongside the `tozd/sympa` image. You
should mount `/etc/sympa/shared` volume into both containers to provide necessary SSH
keys for communication between containers. The volume should contain also `sympa_rewrite`
and `sympa_transport` files configuring the mailing lists which exist.

Example of a `sympa_rewrite` file:

```
/^sympa-request@/	postmaster
/^sympa-owner@/		postmaster
/(.+)-owner@(.+)/	$1+owner@$2
```

Example of a `sympa_transport` file, for each domain you have Sympa providing mailing lists:

```
/^sympa@example\.com$/	 sympadomain:
/^abuse-feedback-report@example\.com$/	 sympabouncedomain:
/^bounce\+.*@example\.com$/	 sympabouncedomain:
/^listmaster@example\.com$/	 sympa:
/^.+(announce|list|info|event|press|talk|news)\+owner@example\.com$/	sympabounce:
/^.+(announce|list|info|event|press|talk|news)(-request|-editor|-subscribe|-unsubscribe)?@example\.com$/	sympa:
```
