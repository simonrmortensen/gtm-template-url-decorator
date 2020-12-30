___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "URL Decorator - Query Parameters",
  "description": "Input the desired query parameter keys and values, or JS-object (dictionaries) with such parameters, to decorate the current URL with, into this variable template.",
  "containerContexts": [
    "WEB"
  ], 
  "categories": ["UTILITY"]
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
    "displayName": "Add Query Parameters from dictionary variable",
    "simpleTableColumns": [
      {
        "defaultValue": "",
        "displayName": "Dictionaries",
        "name": "queryDictionary",
        "type": "TEXT"
      }
    ],
    "newRowButtonText": "Add Query Parameter Dictionary variable",
    "help": "In this table, add dictionary variables which contain key-value pairs representing query parameters ( \u003cstrong\u003e{\"query\":\"parameter\"}\u003c/strong\u003e )."
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
// const print = require('logToConsole');
const getURL = require("getUrl");
const encode = require("encodeUriComponent");
const encoder = require("encodeUri");

const url = getURL("protocol") + "://" + getURL("host") + getURL("path");
const queries = data.stripOriginalQueries ? "" : getURL("query");

let addQueries = [];

const hardQueries = (data.hardQueryParams || []).reduce((agg, current) => {
  agg[current.key] = current.value;
  return agg;
}, {});

const dict = (data.dictionaryQueryParams || []).reduce((agg, current, index) => {
  agg[index] = current;
  return agg;
}, {});

addPairs(hardQueries);
addPairs(dict);

addQueries = addQueries.filter((param, currentIndex) => { 
  // Remove duplicated parameters, if any. 
  const key = param.split("=")[0];
  const inOriginalQueries = queries.indexOf(key) !== -1;
  const alreadyAppended = addQueries.slice(0, currentIndex).some(prev => prev.split("=")[0] === key);
  return !(inOriginalQueries || alreadyAppended);
});

// Variables must return a value.
const separator = queries ? "&" : "?";
const originalQueries = queries ? "?" + queries : "";
const appendQueries = addQueries.length ? separator + addQueries.join("&") : "" ;
return encoder(url + originalQueries + appendQueries);

// Helper functions
function addPairs(dict) {
  if (typeof dict !== "object") { return; }
  
  for (let key in dict) {
    // If URL input queries already contains key, or the value of the key is not a primitive data type, skipping this item. 
    const approvedTypes = ["string", "number", "boolean"];
    if (approvedTypes.indexOf(typeof dict[key]) !== -1) {
      addQueries.push(encode(key) + "=" + encode(dict[key].toString()));
    } else {
      addPairs(dict[key]);
    }
  }
}


___WEB_PERMISSIONS___

[
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
  },
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
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 2020-01-17 23:33:25


