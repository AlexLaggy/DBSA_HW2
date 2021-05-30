from faker import Faker
import random
from datetime import datetime, timedelta
import json

fake = Faker()

news = {i: fake.sentence()[:-1] for i in range(100)}

users = {i: fake.name() for i in range(30)}

interaction = [True, True, False, True, False, True]

data = []

for news_item in news.keys():
    for user in users.keys():
        type_of_interaction = random.choice(range(1, 4))
        data.append({'id_news_item': news_item,
                     'id_user': user,
                     'interaction_time': (datetime.now() - timedelta(hours=random.choice(range(0, 23)),
                                                                     minutes=random.choice(range(0, 59)),
                                                                     seconds=random.choice(range(0, 59)))).strftime("%Y-%m-%d %H:%M:%S"),
                     'id_interaction_type': type_of_interaction
                     })

with open('news_time.log', 'w') as f:
    for row in data:
        f.write(f'{row["id_news_item"]},{row["id_user"]},{row["interaction_time"]},{row["id_interaction_type"]}\n')

with open('news_raw.log', 'w') as f:
    row_data = {}
    for row in data:
        if row['id_news_item'] not in row_data.keys():
            row_data.update({row['id_news_item']: [{'type': i, 'count': 0} for i in range(1, 4)]})
        for slab in row_data.get(row['id_news_item']):
            if slab.get('type') == row['id_interaction_type']:
                slab['count'] += 1
    for key, value in row_data.items():
        tmp = ''
        for row in value:
            tmp += f',{row["type"]},{row["count"]}'
        f.write(f'{key}{tmp}\n')
