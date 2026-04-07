import pandas as pd
import country_converter as coco

cc = coco.CountryConverter()


def normalize_country(name):
    result = cc.convert(names=name,to="name_short")
    if result != "not found":
        return result
    else:
        return name
    

def clean_country(df):
    mapping = {}
    for country in df["country"]:
        normalized = normalize_country(country)
        if country not in mapping:
            mapping[country] = normalized
    df = df.copy()
    df["country_clean"] = df["country"].replace(mapping)
    print(df)
    return df

def test_normalizecountry():
    df = pd.DataFrame()
    df["country"] = ["Congo", "côte d'Ivoire"]
    df_test = pd.DataFrame()
    df_test["country"] = ["Congo Republic","Côte d'Ivoire"]
    tam = len(df_test)
    df_to_test = clean_country(df)
    for i in range(len(df_test)):
        assert df_to_test.iloc[i, 1] == df_test.iloc[i, 0]