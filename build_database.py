import requests
import sqlite_utils

# TODO nested handler https://github.com/dogsheep/github-to-sqlite/blob/2.8.1/github_to_sqlite/utils.py#L787
# https://twitter.com/simonw/status/1333615706605121537

# Ideas stolen from https://github.com/dogsheep/pocket-to-sqlite/blob/0.2.1/pocket_to_sqlite/utils.py#L95

# https://api.finder.partners.aws.a2z.com/search?locale=en&size=100&location=Singapore&from=100
# -H 'Origin: https://partners.amazonaws.com


def fetch():
    offset = 0
    page_size = 1
    while True:
        # headers={"Origin": "whatever"}
        args = {
            "from": offset,
            "size": page_size,
        }
        # https://api.finder.partners.aws.a2z.com/search?size=1&from=0
        response = requests.get("https://api.finder.partners.aws.a2z.com/search", args)
        response.raise_for_status()
        page = response.json()
        print(page)
        # .message.results[]
        # do not understand this code:
        items = list((page["message"]["results"] or {}).values())
        if not items:
            break
        yield from items
        offset += page_size
        sleep(5)

if __name__ == "__main__":
    db = sqlite_utils.Database("aws-partners.db")
    db["partners"].insert_all(fetch(),
        pk="_id",
    )
    # db["partners"].enable_fts(["event_name", "event_description", "facilitators"])
