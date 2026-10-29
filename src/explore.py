from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns


PROJECT_ROOT = Path(__file__).resolve().parent.parent
DATA_PATH = PROJECT_ROOT / 'raw' / 'ml-100k'
FIGURES_PATH = DATA_PATH.parent.parent / 'figures'
FIGURES_PATH.mkdir(parents=True, exist_ok=True)


# u.user
users = pd.read_csv(DATA_PATH / 'u.user', sep='|', header=None, names=['user_id', 'age', 'gender', 'occupation', 'zip_code'], 
                   dtype={'zip_code': 'string'})

# u.item
item_base = ['movie id', 'movie title', 'release date', 'video release date', 'IMDb URL']
item_genres = ['unknown', 'Action', 'Adventure', 'Animation', "Children's", 'Comedy', 'Crime', 'Documentary', 'Drama', 'Fantasy',
               'Film-Noir', 'Horror', 'Musical', 'Mystery', 'Romance','Sci-Fi', 'Thriller', 'War', 'Western'
              ]
item_columns = item_base + item_genres
items = pd.read_csv(DATA_PATH / 'u.item', sep='|', header=None, names=item_columns, encoding='latin-1')

# u.data
data = pd.read_csv(DATA_PATH / 'u.data', sep='\t', header=None, names=['user id', 'item id', 'rating', 'timestamp'])

# chart 1
plt.figure(figsize=(12, 6))
sns.countplot(data=data, x='rating')

plt.title('Distribution of Movie Ratings')
plt.xlabel('Rating')
plt.ylabel('Number of Ratings')
plt.savefig(FIGURES_PATH / 'rating_distribution.png')


# chart 2
plt.figure(figsize=(12, 6))
sns.countplot(data=users, y='occupation', order=users['occupation'].value_counts().index)

plt.title('Number of Users by Occupation')
plt.xlabel('Number of Users')
plt.ylabel('Occupation')
plt.savefig(FIGURES_PATH / 'users_by_occupation.png', dpi=150)

