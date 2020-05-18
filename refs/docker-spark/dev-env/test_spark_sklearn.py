from sklearn.ensemble import RandomForestRegressor
from sklearn.datasets import load_boston
from spark_sklearn import GridSearchCV
import pyspark

if __name__ == '__main__':

    sc = pyspark.SparkContext('local[*]')

    boston = load_boston()

    RAMDON_FOREST_PARAMS = {
        "n_estimators": [100],
        "max_features": [1, "auto", "sqrt", None],
        "max_depth": [1, 5, 10, None],
        "min_samples_leaf": [1, 2, 4, 50]}

    rf = RandomForestRegressor(random_state=0, n_jobs=-1)

    clf = GridSearchCV(sc, rf, RAMDON_FOREST_PARAMS)

    clf.fit(boston.data, boston.target)
    print("parameters for random forest: {0}".format(clf.best_params_), sep="\n")
