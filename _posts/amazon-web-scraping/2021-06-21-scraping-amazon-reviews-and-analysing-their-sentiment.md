---
layout: post
title:  "Scraping Amazon reviews and analysing their sentiment"
comments: true
date:   2021-06-21 21:00:20 +0100
tags: data-analysis
---

**What is web scraping?**

Web scraping consists in systematically collecting information from the Internet. This practice is as old as the internet and there are different techniques to carry it out, being the simplest one the manual copy and paste of information from a web page into a text file or a spreadsheet. Even so, this technique is not the best for quick collection of large amounts of data. Therefore, to collect large volumes of data, techniques that automate this process are used. Generally, these techniques look for patterns that identify what we want to extract. In this example we will use patterns in the HTML structure of the website in order to extract the information we are interested in.

Usually pages of a website serving the same purpose follow a very similar or identical HTML structure. For example, on Amazon all specific product pages follow the same HTML structure. Likewise, all review pages also follow the same HTML structure. This is mainly due to the fact that an underlying structure is usually generated for a specific purpose, which is then used for all the pages that fulfil that purpose. And we will use this fact to automatically retrieve information of our interest.

**Initial Steps**

As with any problem, the first step in web scraping is to define our purpose, i.e. to define what information we want to extract. Once we have defined the information we want to extract, we must define how to extract this information. To do this we must have a good knowledge of the structure of the website from which we want to extract information. Hence, we should carefully analyse this structure, looking for patterns that could help us to extract the desired information. 

**Defining our purpose and examining Amazon’s reviews page structure**

As we said at the beginning, we want to extract product reviews from Amazon. Specifically, we want to extract all the reviews for the specified product, including each review’s text, date and rating. Furthermore, as mentioned above, we will use the HTML structure to extract this information. 

The first thing we will do is to go to any review page, as we want to analyse how that page is structured. In this example we will analyse the structure of the reviews for the Huawei P40 Lite (specifically Huawei P40 Lite Dual 4G JNY-LX1 128GB 6GB RAM International Version No Google Play - Midnight Black). Take into account that the process would be the same for any other product, so feel free to try the same with another product of your choice.

To go to the reviews page of a product on amazon, we just have to search for that product and once we are on the product page go to the bottom of this page where we will see some of the most relevant reviews and below them we will see a link saying "See all reviews", which we will click in order to access to the product reviews page. Figure 1 depicts how to go to the Amazon product reviews page for Huawei P40 Lite.

{% include image.html url="/assets/img/amazon-web-scraping/dark_reviews.gif" description="Figure 1. Going to Amazon Product Reviews Page" %}{: class="darkImage"}
{% include image.html url="/assets/img/amazon-web-scraping/light_reviews.gif" description="Figure 1. Going to Amazon Product Reviews Page" %}{: class="lightImage"}

Here, we can begin inspecting the structure of this page. To do this, we will use the inspect elements tool included in most web browsers. In my case I use chrome as my main browser, so my examples will be based on how it would be done in that browser. However, for other web browsers the process would be almost identical. So, what we will do first is to right-click on the elements we are interested in, i.e. the review date, the review rating and the review text. After right-clicking to that element we select **Inspect**. Now we have access to the browser developer tools and can check the backbone of this page. Again, in this case it makes no difference which review we inspect, as they will all follow the same structure.  

A very useful tool built into chrome for inspecting pages is the element selection tool, which can be used by clicking on this icon <img src="/assets/img/amazon-web-scraping/selectItem.png" alt="select item icon" class="invertImage"> in the top left of the chrome developer tools or by pressing Ctrl + Shift + C. This tool allows you to directly select elements and view their HTML code and properties.  

Figure 2 shows the output of this tool when selecting the first review. In it we can see that the whole review is on a div element with id customer_review-RVCURI5LSCFHO (IDs are preceded by a hashtag symbol). HTML ID attributes are unique identifiers, it is not possible to have more than one element with the same id. For this reason, they are not that useful when scraping websites. However, we can also see that the whole review has several classes (classes are preceded by a dot. Thus each text before a dot corresponds to a class name), such as a-section, review and aok-relative.  Classes are often very important when it comes to establishing patterns through HTML, because their purpose is to identify elements that have a similar purpose in order to attribute the same style to them (for those that are not familiar with HTML and HTML attributes, you can learn more about them [here](https://www.w3schools.com/html/default.asp)).

{% include image.html url="/assets/img/amazon-web-scraping/review_dark.png" description="Figure 2. Selecting a Review" %}{: class="darkImage"}
{% include image.html url="/assets/img/amazon-web-scraping/review_light.png" description="Figure 2. Selecting a Review" %}{: class="lightImage"}

Figures 3, 4 and 5 show the output of the selection tool when selecting the date, score and text of the first review, respectively. In them we can see that both the date and the text of the review are on span elements. While the review is on an i element. Moreover, we can see that each of these elements has several classes.

By checking the classes of these elements, we can see that there are some pretty descriptive classes. For example, the review date has as classes a-size-base, a-color-secondary and review-date; the review rating has as classes a-icon, a-icon-star, a-star-5 and review-rating; the review text has as classes a-size-base, review-text and review-text-content. Here we see that some classes are used in more than one element, e.g. the a-size-base class is found in both the date and the text of the review. However, we want a class or a combination of classes that only identifies each element of interest (it could also be done with elements, ids or combinations of these different types).

{% include image.html url="/assets/img/amazon-web-scraping/reviewdate_dark.png" description="Figure 3. Selecting the Review Date" %}{: class="darkImage"}
{% include image.html url="/assets/img/amazon-web-scraping/reviewdate_light.png" description="Figure 3. Selecting the Review Date" %}{: class="lightImage"}

{% include image.html url="/assets/img/amazon-web-scraping/reviewrating_dark.png" description="Figure 4. Selecting the Review Rating" %}{: class="darkImage"}
{% include image.html url="/assets/img/amazon-web-scraping/reviewrating_light.png" description="Figure 4. Selecting the Review Rating" %}{: class="lightImage"}

{% include image.html url="/assets/img/amazon-web-scraping/reviewtext_dark.png" description="Figure 5. Selecting the Review Text" %}{: class="darkImage"}
{% include image.html url="/assets/img/amazon-web-scraping/reviewtext_light.png" description="Figure 5. Selecting the Review Text" %}{: class="lightImage"}


{% include image.html url="/assets/img/amazon-web-scraping/structure.png" description="Figure 6. Schematic Structure" %}{: class="invertImage"}

