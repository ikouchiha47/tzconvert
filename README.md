# tzconvert

### Installation

Script:

```shell
cp tzconvert ~/.local/bin # given this is in $PATH
```

Completions:

For fish: `cp completions/tzcompletions.fish ~/.config/fish/completions/`

### Usage

```shell
tzconvert Asia/Singapore 18:00

# is the same as
tzconvert Asia/Singapore 18:00 <local time zone>

tz_convert Asia/Kolkata 17:00 Asia/Singapore
```
