# Usage

To get all repositories for an organization
```bash
ruby ght.rb -L -o sampleorg
```

To scan all repositories
```bash
ruby ght.rb -Ls -o sampleorg
```

To list all known vulnerabilities
```bash
ruby ght.rb -Ls -o sampleorg | grep -v?
```

And to see it in an ordered list formatted nicely
```bash
ruby ght.rb -Ls -o prodigyfinance | grep -v ? | grep -v 0 | awk '{ print length, $0 }' | sort -n | cut -d" " -f2- | awk '{ $2="-"; print }' | cat -T | tac
```
