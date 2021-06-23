---
layout: post
title:  "Scraping Amazon reviews and analysing their sentiment"
comments: true
date:   2021-06-21 21:00:20 +0100
tags: data-analysis
---

# What is web scraping?

Web scraping consists in systematically collecting information from the Internet. This practice is as old as the internet and there are different techniques to carry it out, being the simplest one the manual copy and paste of information from a web page into a text file or a spreadsheet. Even so, this technique is not the best for quick collection of large amounts of data. Therefore, to collect large volumes of data, techniques that automate this process are used. Generally, these techniques look for patterns that identify what we want to extract. In this example we will use patterns in the HTML structure of the website in order to extract the information we are interested in.

Usually pages of a website serving the same purpose follow a very similar or identical HTML structure. For example, on Amazon all specific product pages follow the same HTML structure. Likewise, all review pages also follow the same HTML structure. This is mainly due to the fact that an underlying structure is usually generated for a specific purpose, which is then used for all the pages that fulfil that purpose. And we will use this fact to automatically retrieve information of our interest.

# Initial Steps

As with any problem, the first step in web scraping is to define our purpose, i.e. to define what information we want to extract. Once we have defined the information we want to extract, we must define how to extract this information. To do this we must have a good knowledge of the structure of the website from which we want to extract information. Hence, we should carefully analyse this structure, looking for patterns that could help us to extract the desired information. 

## Defining our purpose 

As we said at the beginning, we want to extract product reviews from Amazon. Specifically, we want to extract all the reviews for the specified product, including each review’s text, date and rating. Furthermore, as mentioned above, we will use the HTML structure to extract this information. 

The first thing we will do is to go to any review page, as we want to analyse how that page is structured. In this example we will analyse the structure of the reviews for the Huawei P40 Lite (specifically Huawei P40 Lite Dual 4G JNY-LX1 128GB 6GB RAM International Version No Google Play - Midnight Black). Take into account that the process would be the same for any other product, so feel free to try the same with another product of your choice.

## Examining Amazon’s reviews page structure

### Going to Amazon's reviews page

To go to the reviews page of a product on amazon, we just have to search for that product and once we are on the product page go to the bottom of this page where we will see some of the most relevant reviews and below them we will see a link saying "See all reviews", which we will click in order to access to the product reviews page. Figure 1 depicts how to go to the Amazon product reviews page for Huawei P40 Lite.

{% include image.html url="/assets/img/amazon-web-scraping/dark_reviews.gif" description="Figure 1. Going to Amazon Product Reviews Page" %}{: class="darkImage"}
{% include image.html url="/assets/img/amazon-web-scraping/light_reviews.gif" description="Figure 1. Going to Amazon Product Reviews Page" %}{: class="lightImage"}

### Inspecting the reviews page

Here, we can begin inspecting the structure of this page. To do this, we will use the inspect elements tool included in most web browsers. In my case I use chrome as my main browser, so my examples will be based on how it would be done in that browser. However, for other web browsers the process would be almost identical. So, what we will do first is to right-click on the elements we are interested in, i.e. the review date, the review rating and the review text. After right-clicking to that element we select **Inspect**. Now we have access to the browser developer tools and can check the backbone of this page. Again, in this case it makes no difference which review we inspect, as they will all follow the same structure.  

A very useful tool built into chrome for inspecting pages is the element selection tool, which can be used by clicking on this icon <img src="/assets/img/amazon-web-scraping/selectItem.png" alt="select item icon" class="invertImage"> in the top left of the chrome developer tools or by pressing Ctrl + Shift + C. This tool allows you to directly select elements and view their HTML code and properties.  

Figure 2 shows the output of this tool when selecting the first review. In it we can see that the whole review is on a div element with id **customer_review-RVCURI5LSCFHO** (IDs are preceded by a hashtag symbol). HTML ID attributes are unique identifiers, it is not possible to have more than one element with the same id. For this reason, they are not that useful when scraping websites. However, we can also see that the whole review has several classes (classes are preceded by a dot. Thus each text before a dot corresponds to a class name), such **as a-section**, **review** and **aok-relative**.  Classes are often very important when it comes to establishing patterns through HTML, because their purpose is to identify elements that have a similar purpose in order to attribute the same style to them (for those that are not familiar with HTML and HTML attributes, you can learn more about them [here](https://www.w3schools.com/html/default.asp)).

{% include image.html url="/assets/img/amazon-web-scraping/review_dark.png" description="Figure 2. Selecting a Review" %}{: class="darkImage"}
{% include image.html url="/assets/img/amazon-web-scraping/review_light.png" description="Figure 2. Selecting a Review" %}{: class="lightImage"}

Figures 3, 4 and 5 show the output of the selection tool when selecting the date, score and text of the first review, respectively. In them we can see that both the date and the text of the review are on span elements. While the review is on an i element. Moreover, we can see that each of these elements has several classes.

By checking the classes of these elements, we can see that there are some pretty descriptive classes. For example, the review date has as classes **a-size-base**, **a-color-secondary** and **review-date**; the review rating has as classes **a-icon**, **a-icon-star**, **a-star-5** and **review-rating**; the review text has as classes **a-size-base**, **review-text** and **review-text-content**. Here we see that some classes are used in more than one element, e.g. the a-size-base class is found in both the date and the text of the review. However, we want a class or a combination of classes that only identifies each element of interest (it could also be done with elements, ids or combinations of these different types).

{% include image.html url="/assets/img/amazon-web-scraping/reviewdate_dark.png" description="Figure 3. Selecting the Review Date" %}{: class="darkImage"}
{% include image.html url="/assets/img/amazon-web-scraping/reviewdate_light.png" description="Figure 3. Selecting the Review Date" %}{: class="lightImage"}

{% include image.html url="/assets/img/amazon-web-scraping/reviewrating_dark.png" description="Figure 4. Selecting the Review Rating" %}{: class="darkImage"}
{% include image.html url="/assets/img/amazon-web-scraping/reviewrating_light.png" description="Figure 4. Selecting the Review Rating" %}{: class="lightImage"}

{% include image.html url="/assets/img/amazon-web-scraping/reviewtext_dark.png" description="Figure 5. Selecting the Review Text" %}{: class="darkImage"}
{% include image.html url="/assets/img/amazon-web-scraping/reviewtext_light.png" description="Figure 5. Selecting the Review Text" %}{: class="lightImage"}

### Setting the pattern
After inspecting the page it is obvious that there are a number of classes that define exactly the elements we are interested in. In addition, these classes are very descriptive, making them easy to identify. Thus, whole reviews can be identified with the **review** class, review's ratings can be identified with the **review-rating** class, review's dates can be identified with the **review-date** and review's texts can be identified with the **review-text** class. Figure 6 visually depicts the classes that uniquely identify the elements we are interested in. Therefore, we can extract all this information by extracting the elements containing these classes.

{% include image.html url="/assets/img/amazon-web-scraping/schematic.png" description="Figure 6. Schematic Structure" %}{: class="invertImage"}

# Scraping Reviews with R
## Scraping the first review page
Now after understanding the HTML structure of the page, let’s use the `rvest` package, a package that makes it easy to scrape data from HTML web pages, inspired by libraries like [Beautiful Soup](https://www.crummy.com/software/BeautifulSoup/).

```r
library(rvest)
```

First, we retrieve the HTML code of the website and load it into R. To do so we can use the `read_html( )` function, specifying the website url as a parameter.

```r
# Specify the website URL
url <- "https://www.amazon.com/Huawei-Dual-SIM-Factory-Unlocked-Smartphone/product-reviews/B084YWQF5R/ref=cm_cr_dp_d_show_all_btm?ie=UTF8&reviewerType=all_reviews" 

# Read the website HTML
webpage <- read_html(url)
```

Now that we have the website’s HTML loaded into R, we can extract whatever we are interested in using the `html_nodes( )` function, in which we specify the object obtained using the `read_html( )` function, i.e. webpage as first argument and then as second argument the tag name, class, or id that we want to extract (remember that the class must have a dot . and ids a hash symbol # preceding their name).

First, we extract all the review ratings. To do so we use `html_nodes( )` specifying as second argument the **review** and **review-rating** classes ".review .review-rating". 

```r
ratings <- html_nodes(webpage, ".review .review-rating") 
ratings
```

And as we can see, we obtain the HTML code as an xml nodeset corresponding to all the elements with this class:

<pre><code>
{xml_nodeset (10)}
 [1] &lt;i data-hook="review-star-rating" class="a-icon a-icon-star a-star-5 review-rating"&gt;&lt;span class="a-icon-alt"&gt;5.0 ou ...
 [2] &lt;i data-hook="review-star-rating" class="a-icon a-icon-star a-star-5 review-rating"&gt;&lt;span class="a-icon-alt"&gt;5.0 ou ...
 [3] &lt;i data-hook="review-star-rating" class="a-icon a-icon-star a-star-5 review-rating"&gt;&lt;span class="a-icon-alt"&gt;5.0 ou ...
 [4] &lt;i data-hook="review-star-rating" class="a-icon a-icon-star a-star-1 review-rating"&gt;&lt;span class="a-icon-alt"&gt;1.0 ou ...
 [5] &lt;i data-hook="review-star-rating" class="a-icon a-icon-star a-star-5 review-rating"&gt;&lt;span class="a-icon-alt"&gt;5.0 ou ...
 [6] &lt;i data-hook="review-star-rating" class="a-icon a-icon-star a-star-3 review-rating"&gt;&lt;span class="a-icon-alt"&gt;3.0 ou ...
 [7] &lt;i data-hook="review-star-rating" class="a-icon a-icon-star a-star-4 review-rating"&gt;&lt;span class="a-icon-alt"&gt;4.0 ou ...
 [8] &lt;i data-hook="cmps-review-star-rating" class="a-icon a-icon-star a-star-5 review-rating"&gt;<span class="a-icon-alt"&gt;5 ...
 [9] &lt;i data-hook="cmps-review-star-rating" class="a-icon a-icon-star a-star-5 review-rating"&gt;<span class="a-icon-alt"&gt;5 ...
[10] &lt;i data-hook="cmps-review-star-rating" class="a-icon a-icon-star a-star-5 review-rating"&gt;<span class="a-icon-alt"&gt;5 ...
</code></pre>

What we want though is not the entire HTML object but rather the plain text information inside the object. To do this, we can use the `html_text( )` function specifying as first argument the HTML code obtained for the desired elements, i.e. `ratings` and as second argument `trim = TRUE`. We set trim to TRUE, in order to trim leading and trailing spaces.

```r
ratings <- html_text(ratings, trim = TRUE)
ratings
```
 
<pre><code>
 [1]  "5.0 out of 5 stars" "5.0 out of 5 stars" "5.0 out of 5 stars"
 [4]  "1.0 out of 5 stars" "5.0 out of 5 stars" "3.0 out of 5 stars" 
 [7]  "4.0 out of 5 stars" "5.0 out of 5 stars" "5.0 out of 5 stars"
 [10] "5.0 out of 5 stars" 
</code></pre>

Awesome, now the output is much clearer, obtaining only what we wanted! Now we will proceed to do the same for the other fields (date and review text).

```r
reviews <- html_nodes(webpage, ".review .review-text-content")
reviews <- html_text(reviews, trim = TRUE)
date <- html_nodes(webpage, ".review .review-date")
date <- html_text(date, trim = TRUE)
```
 
Finally, we can add all this information into a matrix:

```r
final_table <- data.frame(reviews, date, ratings)
```


## Scraping all the pages

You may have already noticed, but Amazon does not show all the reviews on a single page, rather it splits the reviews into different pages, showing a maximum of 10 reviews per page. For this reason, in order to extract all the reviews we should repeat the above process for each of the review pages. Therefore, we could perform two basic procedures to achieve that:

1. Scrape the total number of reviews, divide it by 10 in order to obtain the total number of pages. Then, use a **for** loop to iterate between all these pages and extract the date, the text and the rating for all the reviews in each page.
2. Use a **while** loop to iterate between pages and extract the date, the text and the rating for all the reviews in that page while elements of class **review** are found on that page.

In this example we will use method 2. 

### Iterating between pages

To iterate between pages, we must first understand how links work on Amazon. The link to the amazon reviews page for the product from which we are scraping reviews in this example is the following: [https://www.amazon.com/Huawei-Dual-SIM-Factory-Unlocked-Smartphone/product-reviews/B084YWQF5R/ref=cm_cr_dp_d_show_all_btm?ie=UTF8&reviewerType=all_reviews](https://www.amazon.com/Huawei-Dual-SIM-Factory-Unlocked-Smartphone/product-reviews/B084YWQF5R/ref=cm_cr_dp_d_show_all_btm?ie=UTF8&reviewerType=all_reviews). As you can see, it is quite a long link. This is because it incorpates a query string, i.e. a part of a URL that assigns values to specicified parameters. Hence, we could simplify the URL by deleting this part, as we don't need to set any parameters right now, obtaining the following simplified version of the URL: [https://www.amazon.com/Huawei-Dual-SIM-Factory-Unlocked-Smartphone/product-reviews/B084YWQF5R/](https://www.amazon.com/Huawei-Dual-SIM-Factory-Unlocked-Smartphone/product-reviews/B084YWQF5R/).

Now, the URL looks much more simpler. But actually that URL incorporates the product title (Huawei-Dual-SIM-Factory-Unlocked-Smartphone) and the product code (B084YWQF5R). Amazon only requires the product code. Thus, we can further simplify this URL by deleting the product title: [https://www.amazon.com/product-reviews/B084YWQF5R/](https://www.amazon.com/product-reviews/B084YWQF5R/).

After having simplified the URL, we can check what happens when we go to the next page by clicking the **Next page** button. And by doing so we can spot that now the URL is the following: [https://www.amazon.com/product-reviews/B084YWQF5R/pageNumber=2](https://www.amazon.com/product-reviews/B084YWQF5R/pageNumber=2). A parameter, called pageNumber, with value equal to 2 has been added to the URL (in case that other parameters were added to your URL, you can delete them). Now as a sanity check we can press again the **Next page** button, seeing that the the value of this parameter has changed to 3.

So, it seems that we have already found a way to iterate between the different pages. We only need to paste a page number at the end of the following url: https://www.amazon.com/product-reviews/B084YWQF5R/pageNumber=


### Extracting all the reviews

To extract all the reviews the first thing we do is to define the URL on which we will iterate, i.e. the URL to which we will add the page number (https://www.amazon.com/product-reviews/B084YWQF5R/pageNumber=). After that, we will define a variable called `pageNumber` with an initial value of 1. This is the variable on which we will iterate and which we will add at the end of the url, in order to refer to the reviews page we want to access.

The URL that will be used to download the website's HTML is going to be the result of pasting https://www.amazon.com/product-reviews/B084YWQF5R/pageNumber= and the page number (`pageNumber`).

Furthermore, in this case we will need to create a priori an empty matrix to which we will add the values extracted for each page.

Thus, the R code to extract all the reviews for the Huawei P40 Lite would be the following:

```r
url <- "https://www.amazon.com/product-reviews/B084YWQF5R/pageNumber="
pageNumber <- 1
webpage <- read_html(paste0(url, pageNumber))
#create an empty data frame 
#(later we will have to delete first row as it will be empty)
final_table <- matrix(ncol = 3, nrow = 1)

#while there are elements with "review" class in webpage
while (length(html_nodes(webpage, ".review")) > 0) {
  #Pick all the information we want for that page (ratings, date and text)
  ratings <- html_nodes(webpage, ".review .review-rating")
  ratings <- html_text(ratings, trim = TRUE)
  reviews <- html_nodes(webpage, ".review .review-text-content")
  reviews <- html_text(reviews, trim = TRUE)
  date <- html_nodes(webpage, ".review .review-date")
  date <- html_text(date, trim = TRUE)
  # Add this information to final_table
  table <- cbind(ratings, reviews, date)
  final_table <- rbind(final_table, table)
  #Increase page Number
  pageNumber <- pageNumber + 1 
  #Update web page
  webpage <- read_html(paste0(url, pageNumber))
}

#Convert final table into a data frame
final_table <- as.data.frame(final_table)
#Remove the first row, which is empty
final_table <- final_table[-1,]
#Set Column names
colnames(final_table) <- c("Rating", "ReviewText", "Date")
#Text may be read as Factor, so convert it into character
final_table$ReviewText <- as.character(final_table$ReviewText) 
```

## Scraping reviews for multiple products 

The above code can be easily adapted to extract reviews of multiple products. To do so, we only have to make three changes:
1. Define a vector with the product codes of the items for which we want to extract reviews.
2. Iterate between these product codes and thus updating the url (i.e. changing the product code).
3. Add an additional column to the data frame storing all the extracted information, in order to correctly identify to which product this information belongs to.

Finally, we also preprocess the extracted date, since it incorporates information about the country in which the product was reviewed and the rating, which is in format X out of 5.0 where we only want X, which is the rating given by the reviewer (a number between 1 and 5).

**Note:** Usually before adapting the code for multiple products it's important to double check that other pages follow the same structure

```r
# product codes of items we want to extract should be specified here
product_codes <- c() 
#final table now has an additional column to store the product code
final_table <- matrix(ncol = 4, nrow = 1)
for (product_code in product_codes) {
  #URL updates product code by pasting its value
  url <- paste0("https://www.amazon.com/product-reviews/", product_code, 
         "/?pageNumber=")
  pageNumber <- 1
  webpage <- read_html(paste0(url, pageNumber))


  
  while (length(html_nodes(webpage, ".review")) > 0) {
    ratings <- html_nodes(webpage, ".review .review-rating")
    ratings <- html_text(ratings, trim = TRUE)
    reviews <- html_nodes(webpage, ".review .review-text-content")
    reviews <- html_text(reviews, trim = TRUE)
    date <- html_nodes(webpage, ".review .review-date")
    date <- html_text(date, trim = TRUE)
    #Add the product code in the table
    table <- cbind(ratings, reviews, date, rep(product_code, 
             length(reviews)))
    final_table <- rbind(final_table, table)
    #Increase page Number
    pageNumber <- pageNumber + 1 
    #Update web page
    webpage <- read_html(paste0(url, pageNumber))
  }
}


final_table <- as.data.frame(final_table)
final_table <- final_table[-1,]
colnames(final_table) <- c("Rating", "ReviewText", "Date", "ProductCode")
#Text may be read as Factor, so convert it into character
final_table$ReviewText <- as.character(final_table$ReviewText) 
#date contains also location information, we remove it
final_table$Date <-  gsub(".*on ", "", final_table$Date) 
#Rating is in format x out of 5 stars, we only need x
final_table$Rating <-  gsub(" out.*", "", final_table$Rating) 
#Convert Rating to Numeric
final_table$Rating <- as.numeric(final_table$Rating) 
```

### Making the code more reusable

The previous code could be converted into a function for better reusability. Furthermore, we applied an additional change: storing the product name instead of the product code.

```r
getReviewsFromAmazon <- function(product_codes, product_names = c()){
#We define two additional columns, one for date and the other for stars
  final_table <- matrix(ncol = 4, nrow = 1) 
  for (product_code in product_codes) {
  
    url <- paste0("https://www.amazon.com/product-reviews/", product_code, 
           "/?pageNumber=")
    pageNumber <- 1
    webpage <- read_html(paste0(url, pageNumber))
    
    while (length(html_nodes(webpage, ".review")) > 0) {
      reviews <- html_nodes(webpage, ".review-text-content")
      reviews <- html_text(reviews, trim = TRUE)
      date <- html_nodes(webpage, ".review .review-date") 
      date <- html_text(date, trim = TRUE)
      ratings <- html_nodes(webpage, ".review .review-rating")
      ratings <- html_text(ratings, trim = TRUE)
      table <- cbind(ratings, reviews, date, rep(product_code, 
             length(reviews)))
      final_table <- rbind(final_table, table)
      pageNumber <- pageNumber + 1
      webpage <- read_html(paste0(url, pageNumber))
    }
  }
  
  final_table <- as.data.frame(final_table)
  final_table <- final_table[-1,]
  colnames(final_table) <- c("Rating", "ReviewText", "Date", "ProductCode")
  #Text may be read as Factor, so convert it into character
  final_table$ReviewText <- as.character(final_table$ReviewText) 
  #date contains also location information, we remove it
  final_table$Date <-  gsub(".*on ", "", final_table$Date) 
  #Rating is in format x out of 5 stars, we only need x
  final_table$Rating <-  gsub(" out.*", "", final_table$Rating) 
  #Convert Rating to Numeric
  final_table$Rating <- as.numeric(final_table$Rating) 
  final_table$ProductCode <- as.factor(final_table$ProductCode)
  #Change the product codes to the product names
  #we use the order and match functions to use the same order
  #as in the function parameter
  levels(final_table$ProductCode)[order(match(product_codes,
         levels(final_table$ProductCode)))] <- product_names 
  return(final_table)
}

```

## Extracting Reviews for the Moto G Stylues and the Samsung S20

Now that we have the automatized the scraping process, we are going to gather the reviews for two smartphones: (https://www.amazon.com/dp/B084CVPLLC/)[Moto G Stylus] and (https://www.amazon.com/dp/B08KVGYH6Z/)[Samsung S20]. To do so, we will use the previous function, `getReviewsFromAmazon( )`. This function takes two arguments, the first one is a vector of the product codes to be retrieved and the second one is a vector containing the name of the products. The latter is only for convenience, as displaying the product name (any name can be specified, it is only used for display purposes, not gathering) is more useful than its code. 

```r
reviews <- getReviewsFromAmazon(c("B084CVPLLC", "B08KVGYH6Z"), c("Moto G Stylus", "Samsung S20"))
```

{% include image.html url="/assets/img/amazon-web-scraping/ViewScrapedReviews.PNG" description="Figure 7. View of getReviewsFromAmazon() output" %}{: class="invertImage"}

