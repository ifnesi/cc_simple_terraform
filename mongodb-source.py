import sys
import pymongo
import urllib.parse


my_client = pymongo.MongoClient(
    f"mongodb+srv://mongodb-demo:{urllib.parse.quote(sys.argv[2])}@{sys.argv[1]}"
)

db = my_client["confluent_demo"]
col = db["users"]
user_data = {
    "name": "John",
    "address": "Highway 37",
}
record = col.insert_one(user_data)
print(record.inserted_id)
