The idea behind this project is to use fetch.sh to scrape the AWS [Find a Partner Portal](https://partners.amazonaws.com/), so that the data can be:

1. Viewed in [Datasette](https://datasette.io/)
2. A snapshot of that data is commited to git, so that we can build a history of Partner progress, for example in .github/workflows/history.yml

Note: For python package management we use https://docs.astral.sh/uv/