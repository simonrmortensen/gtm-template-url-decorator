___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "URL Decorator - Query Parameters [UNPUBLISHED]",
  "description": "Input the desired query parameter keys and values, or JS-object (dictionaries) with such parameters, to decorate the current URL with, into this variable template.",
  "containerContexts": [
    "WEB"
  ],
  "categories": [
    "UTILITY"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SIMPLE_TABLE",
    "name": "hardQueryParams",
    "displayName": "Query Parameter Keys and Values",
    "simpleTableColumns": [
      {
        "defaultValue": "",
        "displayName": "Key",
        "name": "key",
        "type": "TEXT"
      },
      {
        "defaultValue": "",
        "displayName": "Value",
        "name": "value",
        "type": "TEXT"
      }
    ],
    "help": "In this table, input the query parameter keys and values that you\u0027d like to decorate your URL with.",
    "alwaysInSummary": false,
    "newRowButtonText": "Add Query Parameters"
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "dictionaryQueryParams",
    "displayName": "Add Query Parameters from JS-object variable",
    "simpleTableColumns": [
      {
        "defaultValue": "",
        "displayName": "JS-objects (Dictionaries)",
        "name": "query_js_object",
        "type": "TEXT"
      }
    ],
    "newRowButtonText": "Add Key/Value JS-object variable",
    "help": "In this table, add JS-object variables which contain key-value pairs representing query parameters ( \u003cstrong\u003e{\"query\":\"parameter\"}\u003c/strong\u003e )."
  },
  {
    "type": "CHECKBOX",
    "name": "stripOriginalQueries",
    "checkboxText": "Strip Original Query Parameters",
    "simpleValueType": true,
    "help": "Tick this box if you don\u0027t want to include the query parameters that are already in the URL.",
    "displayName": "Strip Original Query Parameters",
    "defaultValue": false
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

// Enter your template code here.
const print = require('logToConsole');
const getURL = require("getUrl");
const encode = require("encodeUriComponent");
const encoder = require("encodeUri");

const url = getURL("protocol") + "://" + getURL("host") + getURL("path");
const queries = data.stripOriginalQueries ? "" : getURL("query");

const addQueries = [];

const hardQueries = (data.hardQueryParams || []).reduce((agg, current) => {
  agg[current.key] = current.value;
  return agg;
}, {});

const dicts = (data.dictionaryQueryParams || []).reduce((agg, current, index) => {
  agg[index] = current;
  return agg;
}, {});

addPairs(hardQueries, addQueries);
addPairs(dicts, addQueries);

// Variables must return a value.
const separator = queries ? "&" : "?";
const originalQueries = queries ? "?" + queries : "";
const appendQueries = addQueries.length ? separator + addQueries.join("&") : "" ;
return encoder(url + originalQueries + appendQueries);

// Helper functions
function addPairs(fromDict, toList) {
  if (typeof fromDict !== "object") { return; }
  
  for (let key in fromDict) {
    // If URL input queries already contains key, or the value of the key is not a primitive data type, skipping this item. 
    const isApprovedType = ["string", "number", "boolean"].indexOf(typeof fromDict[key]) !== -1;
    const isDuplicate = ((keyName, queryList) => {
      // Remove duplicated parameters, if any. 
      const inOriginalQueries = queries.indexOf(keyName + "=") !== -1;
      const alreadyAppended = queryList.some(prev => prev.split("=")[0] === keyName);
      return inOriginalQueries || alreadyAppended;
    })(key, toList);
        
    if (isApprovedType && !isDuplicate) {
      addQueries.push(encode(key) + "=" + encode(fromDict[key].toString()));
    } else {
      addPairs(fromDict[key]);
    }
  }
}


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "get_url",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urlParts",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "queriesAllowed",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 2020-01-17 23:33:25


