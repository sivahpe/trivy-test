# (C) Copyright 2023 Hewlett Packard Enterprise Development LP

# FROM gcr.io/distroless/static-debian12:nonroot as no-vulns

# FROM scratch as unsupported-os

# # Needs a file
# COPY --from=no-vulns /etc/host.conf /host.conf

# FROM appsecco/dsvw@sha256:f5d2da93ea8859b89c8d36e8c0cda936b9238854f3c06c44d1585ae0ffd205cf as vulns

# FROM scratch as medium-vulns

# # This is just a node module with jquery@3.2.1 added, got from
# # https://github.com/aquasecurity/trivy/blob/main/integration/testdata/yarn.json.golden
# ADD med-vuln.tar /

FROM nginx:latest