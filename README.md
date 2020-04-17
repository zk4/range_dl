make curl multihreadable
# Usage 

``` bash

pip isntall range_dl
```


# Example 
``` bash
range_dl -c "curl  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3628.2 Safari/537.36' -H 'Referer: https://www.bilibili.com/video/BV1RE411k7aL?p=9'  'http://upos-sz-mirrorhw.bilivideo.com/upgcxcode/76/51/127435176/127435176-1-30066.m4s?e=ig8euxZM2rNcNbdlhoNvNC8BqJIzNbfqXBvEqxTEto8BTrNvN0GvT90W5JZMkX_YN0MvXg8gNEV4NC8xNEV4N03eN0B5tZlqNxTEto8BTrNvNeZVuJ10Kj_g2UB02J0mN0B5tZlqNCNEto8BTrNvNC7MTX502C8f2jmMQJ6mqF2fka1mqx6gqj0eN0B599M=&uipk=5&nbs=1&deadline=1587141766&gen=playurl&os=hwbv&oi=1875304758&trid=3f395db327314ad499b5d607fe81aca9u&platform=pc&upsig=135d6d1c9664c0b496a7bd5a80051d93&uparams=e,uipk,nbs,deadline,gen,os,oi,trid,platform&mid=0&logo=80000000'" | mpv -

```
# TODO
1. smart range for fast preview, some media file need to read last few bytes.
