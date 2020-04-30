### dog.jpg

```bash
curl raw.github.com/jeromedecoster/dog/master/script.sh \
    --location \
    --silent \
    | bash
```

### wget

```bash
wget raw.github.com/jeromedecoster/dog/master/script.sh \
    --output-document=- \
    --quiet \
    | bash
```
