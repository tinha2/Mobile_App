//
//  JsonSample.swift
//  DeepSocial
//
//  Created by Chung BD on 6/24/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import Foundation

let JSON_STRING = """
{
"sentences": [
{
"text": {
"content": "Google, headquartered in Mountain View, unveiled the new Android phone at the Consumer Electronic Show.",
"beginOffset": 0
},
"sentiment": {
"magnitude": 0,
"score": 0
}
},
{
"text": {
"content": "Sundar Pichai said in his keynote that users love their new Android phones.",
"beginOffset": 105
},
"sentiment": {
"magnitude": 0.6,
"score": 0.6
}
}
],
"tokens": [],
"entities": [
{
"name": "Google",
"type": "ORGANIZATION",
"metadata": {
"mid": "/m/045c7b",
"wikipedia_url": "https://en.wikipedia.org/wiki/Google"
},
"salience": 0.25572062,
"mentions": [
{
"text": {
"content": "Google",
"beginOffset": 0
},
"type": "PROPER",
"sentiment": {
"magnitude": 0,
"score": 0
}
}
],
"sentiment": {
"magnitude": 0,
"score": 0
}
},
{
"name": "users",
"type": "PERSON",
"metadata": {},
"salience": 0.1527633,
"mentions": [
{
"text": {
"content": "users",
"beginOffset": 144
},
"type": "COMMON",
"sentiment": {
"magnitude": 0,
"score": 0
}
}
],
"sentiment": {
"magnitude": 0.9,
"score": 0.4
}
},
{
"name": "phone",
"type": "CONSUMER_GOOD",
"metadata": {},
"salience": 0.13119894,
"mentions": [
{
"text": {
"content": "phone",
"beginOffset": 65
},
"type": "COMMON",
"sentiment": {
"magnitude": 0,
"score": 0
}
}
],
"sentiment": {
"magnitude": 0,
"score": 0
}
},
{
"name": "Android",
"type": "CONSUMER_GOOD",
"metadata": {
"mid": "/m/02wxtgw",
"wikipedia_url": "https://en.wikipedia.org/wiki/Android_(operating_system)"
},
"salience": 0.122452624,
"mentions": [
{
"text": {
"content": "Android",
"beginOffset": 57
},
"type": "PROPER",
"sentiment": {
"magnitude": 0,
"score": 0
}
},
{
"text": {
"content": "Android",
"beginOffset": 165
},
"type": "PROPER",
"sentiment": {
"magnitude": 0.2,
"score": 0.2
}
}
],
"sentiment": {
"magnitude": 0.2,
"score": 0.1
}
},
{
"name": "Sundar Pichai",
"type": "PERSON",
"metadata": {
"mid": "/m/09gds74",
"wikipedia_url": "https://en.wikipedia.org/wiki/Sundar_Pichai"
},
"salience": 0.11414111,
"mentions": [
{
"text": {
"content": "Sundar Pichai",
"beginOffset": 105
},
"type": "PROPER",
"sentiment": {
"magnitude": 0,
"score": 0
}
}
],
"sentiment": {
"magnitude": 0.1,
"score": 0
}
},
{
"name": "Mountain View",
"type": "LOCATION",
"metadata": {
"mid": "/m/0r6c4",
"wikipedia_url": "https://en.wikipedia.org/wiki/Mountain_View,_California"
},
"salience": 0.101959646,
"mentions": [
{
"text": {
"content": "Mountain View",
"beginOffset": 25
},
"type": "PROPER",
"sentiment": {
"magnitude": 0,
"score": 0
}
}
],
"sentiment": {
"magnitude": 0,
"score": 0
}
},
{
"name": "Consumer Electronic Show",
"type": "EVENT",
"metadata": {
"mid": "/m/01p15w",
"wikipedia_url": "https://en.wikipedia.org/wiki/Consumer_Electronics_Show"
},
"salience": 0.070343755,
"mentions": [
{
"text": {
"content": "Consumer Electronic Show",
"beginOffset": 78
},
"type": "PROPER",
"sentiment": {
"magnitude": 0,
"score": 0
}
}
],
"sentiment": {
"magnitude": 0,
"score": 0
}
},
{
"name": "phones",
"type": "CONSUMER_GOOD",
"metadata": {},
"salience": 0.03383166,
"mentions": [
{
"text": {
"content": "phones",
"beginOffset": 173
},
"type": "COMMON",
"sentiment": {
"magnitude": 0.7,
"score": 0.7
}
}
],
"sentiment": {
"magnitude": 0.7,
"score": 0.7
}
},
{
"name": "keynote",
"type": "OTHER",
"metadata": {},
"salience": 0.01758835,
"mentions": [
{
"text": {
"content": "keynote",
"beginOffset": 131
},
"type": "COMMON",
"sentiment": {
"magnitude": 0,
"score": 0
}
}
],
"sentiment": {
"magnitude": 0,
"score": 0
}
}
],
"documentSentiment": {
"magnitude": 0.6,
"score": 0.3
},
"language": "en",
"categories": [
{
"name": "/Computers & Electronics",
"confidence": 0.61
},
{
"name": "/Internet & Telecom/Mobile & Wireless",
"confidence": 0.53
},
{
"name": "/News",
"confidence": 0.53
}
]
}
"""

let JSON_STRING_IMAGE_EXTRACTION = """
{
"labelAnnotations": [
{
"mid": "/m/02n3pb",
"description": "product",
"score": 0.7420468,
"topicality": 0.7420468
},
{
"mid": "/m/03gq5hm",
"description": "font",
"score": 0.7034471,
"topicality": 0.7034471
},
{
"mid": "/m/01jwgf",
"description": "product",
"score": 0.6364999,
"topicality": 0.6364999
},
{
"mid": "/m/01cd9",
"description": "brand",
"score": 0.599291,
"topicality": 0.599291
},
{
"mid": "/m/0dwx7",
"description": "logo",
"score": 0.59745204,
"topicality": 0.59745204
},
{
"mid": "/m/0mwc",
"description": "angle",
"score": 0.5825281,
"topicality": 0.5825281
},
{
"mid": "/m/0j62f",
"description": "rectangle",
"score": 0.5699679,
"topicality": 0.5699679
},
{
"mid": "/m/021sdg",
"description": "graphics",
"score": 0.5232849,
"topicality": 0.5232849
}
],
"safeSearchAnnotation": {
"adult": "VERY_UNLIKELY",
"spoof": "VERY_LIKELY",
"medical": "UNLIKELY",
"violence": "UNLIKELY",
"racy": "VERY_UNLIKELY"
},
"webDetection": {
"webEntities": [
{
"entityId": "/m/0105pbj4",
"score": 0.8616,
"description": "Google Cloud Platform"
},
{
"entityId": "/m/040sd3",
"score": 0.781539,
"description": "Luna Park Sydney"
},
{
"entityId": "/m/0701q",
"score": 0.72509253,
"description": "Sydney Harbour Bridge"
},
{
"entityId": "/t/24bjj59_jbj9f",
"score": 0.5958
},
{
"entityId": "/g/11bxfg6b1k",
"score": 0.55011004,
"description": "Bradfield Park"
},
{
"entityId": "/m/045c7b",
"score": 0.4766,
"description": "Google"
},
{
"entityId": "/m/02y_9m3",
"score": 0.4682,
"description": "Cloud computing"
},
{
"entityId": "/m/010jjr",
"score": 0.43470168,
"description": "Amusement park"
},
{
"entityId": "/t/224z0bg5hhnn0",
"score": 0.421
},
{
"entityId": "/g/121pk5nw",
"score": 0.3947,
"description": "WEB.DE"
}
],
"fullMatchingImages": [
{
"url": "https://is2-ssl.mzstatic.com/image/thumb/Purple128/v4/ff/bb/e5/ffbbe598-2d65-afce-d0c7-4a1741e79c62/mzl.xbvlzflc.jpg/246x0w.jpg"
},
{
"url": "https://is2-ssl.mzstatic.com/image/thumb/Purple128/v4/ff/bb/e5/ffbbe598-2d65-afce-d0c7-4a1741e79c62/mzl.xbvlzflc.jpg/200x0w.jpg"
},
{
"url": "https://store-images.s-microsoft.com/image/apps.64241.13510798884381219.0caf7424-50b5-4a55-86fc-1a366c5ad008.010cc2bb-5713-43a5-befa-49e3b8a08cb4?w=100&amp,h=100&amp,q=60"
}
],
"pagesWithMatchingImages": [
{
"url": "https://www.cre8ivedance.co.uk/secure/workshops/placeholder-square/",
"pageTitle": "<b>placeholder</b>-<b>square</b> - Cre8ive Dance Academy",
"fullMatchingImages": [
{
"url": "https://www.cre8ivedance.co.uk/secure/wp-content/uploads/2017/12/placeholder-square.jpg"
}
]
},
{
"url": "http://www.22bulbjungle.com/make-a-gif-from-a-video-just-like-in-tumblr/placeholder-square/",
"pageTitle": "<b>placeholder</b>-<b>square</b> - 22bulbjungle",
"fullMatchingImages": [
{
"url": "http://www.22bulbjungle.com/wp-content/uploads/2016/11/placeholder-square.jpg"
}
]
},
{
"url": "http://ryanacademy.ie/portfolio/horizon-2020-startup-lighthouse/",
"pageTitle": "Horizon 2020 – Startup LIGHTHOUSE - Ryan Academy",
"fullMatchingImages": [
{
"url": "http://ryanacademy.ie/wp-content/uploads/2017/08/placeholder-Copy-3-420x400.png"
},
{
"url": "http://ryanacademy.ie/wp-content/uploads/2017/08/placeholder-Copy-420x400.png"
},
{
"url": "http://ryanacademy.ie/wp-content/uploads/2017/08/placeholder-1-420x400.png"
}
]
},
{
"url": "http://ryanacademy.ie/portfolio/eciu-start-up/",
"pageTitle": "ECIU Start-Up - Ryan Academy",
"fullMatchingImages": [
{
"url": "http://ryanacademy.ie/wp-content/uploads/2017/08/placeholder-Copy-3-420x400.png"
},
{
"url": "http://ryanacademy.ie/wp-content/uploads/2017/08/placeholder-Copy-420x400.png"
},
{
"url": "http://ryanacademy.ie/wp-content/uploads/2017/08/placeholder-1-420x400.png"
}
]
},
{
"url": "http://www.22bulbjungle.com/image-sitemap-1.xml",
"pageTitle": "http://www.22bulbjungle.com/22/ 2016-10-04T09:34:09Z http://www ...",
"fullMatchingImages": [
{
"url": "http://www.22bulbjungle.com/wp-content/uploads/2016/11/placeholder-square.jpg"
}
]
},
{
"url": "https://rockproject.eu/contact",
"pageTitle": "contact - ROCK - Cultural Heritage leading urban futures",
"fullMatchingImages": [
{
"url": "https://rockproject.eu/img/placeholder-square.jpg"
}
]
},
{
"url": "https://www.diggz.co/search-city/philadelphia",
"pageTitle": "Find an amazing roommate or a room for rent in Philadelphia - Diggz",
"fullMatchingImages": [
{
"url": "https://www.diggz.co/assets/default.jpg"
}
]
},
{
"url": "https://www.diggz.co/search-city/boston",
"pageTitle": "Find an amazing roommate or a room for rent in Boston - Diggz",
"fullMatchingImages": [
{
"url": "https://www.diggz.co/assets/default.jpg"
}
]
},
{
"url": "http://www.mp.nic.in/nkn_images_5.html",
"pageTitle": "Visit of Dr. Sam Pitroda with Sh. R.Gopalakrishnan to NKN ... - NIC MP",
"fullMatchingImages": [
{
"url": "http://www.mp.nic.in/images_boot/mp14/placeholder.jpg"
}
]
},
{
"url": "https://jodino1matrimony.com/img/",
"pageTitle": "Index of /img - Jodi No.1 Matrimony",
"fullMatchingImages": [
{
"url": "https://jodino1matrimony.com/img/square.jpg"
}
]
}
]
}
}
"""

let JSON_STRING_TEXT_ANNOTATION = """
{
"textAnnotations": [
{
"boundingPoly" :
{
"vertices" : [
{
"x" : 65,
"y" : 109
},
{
"x" : 187,
"y" : 109
},
{
"x" : 187,
"y" : 136
},
{
"x" : 65,
"y" : 136
}
]
},
"description" : "MANOIBUS",
"locale" : "la"
},
{
"boundingPoly" :
{
"vertices" : [
{
"x" : 65,
"y" : 109
},
{
"x" : 187,
"y" : 109
},
{
"x" : 187,
"y" : 136
},
{
"x" : 65,
"y" : 136
}
]
},
"description" : "MANOIBUS"
}
]
}
"""

let JSON_STRING_VOICE_SYNTHESIS = """
{
"results": [
{
"alternatives": [
{
"transcript": "how old is the Brooklyn Bridge",
"confidence": 0.98267895
}
]
}
]
}
"""

let JSON_STRING_IMAGE_PROPERTIES = """
{
"imagePropertiesAnnotation": {
"dominantColors": {
"colors": [
{
"color": {
"red": 69,
"green": 42,
"blue": 27
},
"score": 0.15197733,
"pixelFraction": 0.14140345
},
{
"color": {
"red": 159,
"green": 193,
"blue": 252
},
"score": 0.12624279,
"pixelFraction": 0.046971671
},
{
"color": {
"red": 25,
"green": 18,
"blue": 13
},
"score": 0.12161674,
"pixelFraction": 0.15410289
},
{
"color": {
"red": 120,
"green": 168,
"blue": 250
},
"score": 0.06179978,
"pixelFraction": 0.018316509
},
{
"color": {
"red": 61,
"green": 46,
"blue": 28
},
"score": 0.068530552,
"pixelFraction": 0.052263107
},
{
"color": {
"red": 181,
"green": 202,
"blue": 239
},
"score": 0.061842542,
"pixelFraction": 0.030364702
},
{
"color": {
"red": 131,
"green": 168,
"blue": 234
},
"score": 0.054366827,
"pixelFraction": 0.018153695
},
{
"color": {
"red": 122,
"green": 162,
"blue": 249
},
"score": 0.039461233,
"pixelFraction": 0.010827092
},
{
"color": {
"red": 39,
"green": 27,
"blue": 12
},
"score": 0.034653772,
"pixelFraction": 0.02596874
},
{
"color": {
"red": 51,
"green": 24,
"blue": 12
},
"score": 0.033614498,
"pixelFraction": 0.024991859
}
]
}
}
}
"""
