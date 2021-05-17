#bin/bash

for alias in hot_clicks_191019 hot_clicks_191018 hot_clicks_191031 hot_clicks_191030 hot_clicks_191015 hot_clicks_191014 hot_clicks_191017 hot_clicks_191016 hot_clicks_191011 hot_clicks_191010 hot_clicks_191013 hot_clicks_191012 hot_clicks_191008 hot_clicks_191007 hot_clicks_191029 hot_clicks_191009 hot_clicks_191020 hot_clicks_191004 hot_clicks_191026 hot_clicks_191003 hot_clicks_191025 hot_clicks_191006 hot_clicks_191028 hot_clicks_191005 hot_clicks_191027 hot_clicks_191022 hot_clicks_191021 hot_clicks_191002 hot_clicks_191024 hot_clicks_191001 hot_clicks_191023; 
do 
    # curl -X POST "http://localhost:9200/hot_$alias"
    # curl -X POST "http://localhost:9200/_aliases" -d "{\"actions\":[{\"add\":{\"index\":\"hot_$alias\",\"alias\":\"$alias\"}}]}" 
    # curl -X POST "http://localhost:9200/_aliases" -d "{\"actions\":[{\"add\":{\"index\":\"hot_$alias\",\"alias\":\"clicks\"}}]}"
    curl -H "Content-Type: application/json" -XPOST "http://localhost:9200/$alias/new/optionalUniqueId" -d "{ \"field\" : \"value\"}"
    
done