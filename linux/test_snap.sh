snapcraft && \
sudo snap remove go-sleep && \
sudo snap install --dangerous --devmode ./go-sleep_0.1_amd64.snap && \
go-sleep;