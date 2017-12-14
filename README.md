# ListDoc Module 
Module version of [DashboardListDoc-widget](https://github.com/Nicola1971/DashboardListDoc-widget)

A small Documents grid/list module for **Evolution CMS 1.4** based on DocLister

Requires snippets: DocLister, DocInfo, If, PhpThumb.

Includes **Tree2ListDocConnect plugin** to connect a resource on the treemenu to the ListDoc Module (optional)  https://www.youtube.com/watch?v=mBnTGEfi9EY

![module](https://user-images.githubusercontent.com/7342798/33998465-d63bf4ce-e0e7-11e7-9ce9-79f59edd2fc0.png)


## Features:
- **Configurable toggle overview row with tvs** (add any tv to the resource toggle overview)
- Main **Doclister parameters** available in plugin config
- **More actions buttons**: edit, preview, move, publish/unpublish, create resource here, delete, overview 
- **Hide some actions buttons to get more space**: you can hide from plugin settings: move, publish/unpublish, create resource here, delete
- **parent column** (click on parent name to view children tab)  [optional]
- **right click Context Menu on Parent** field (view childern, edit, add resource here, add weblink here)
- **tv columns**: add custom tv in sortable columns  [optional]
- **image tv** in overview or column  [optional]
- **Sortable columns** (title/parent/date/custom tv columns)
- **Filtering** (search)
- **Filter options** (choose "search in")
- **Pagination**
- **Status Filter** (published, unpublished, deleted) [optional]
- **Edit in Evo Modal**: edit and create documents in Evo (1.4) modal/popup [optional]
- **Full Localstorage support**: state of pagination , search and sorting is always saved in localhost - so when you go back to the dashboard, you dont need to search or sort again
- **Multilanguage** 


# Module Settings

### Doclister params Settings

* **Parent folder for List documents**: parents
* **Max items in List**: display
* **Depht**: depth 
* **Hide Folders**: addWhereList isfolder=0
* **Show Deleted and Unpublished**: showNoPublish

### Widget & Grid Settings

* **Show Create Resource Buttons**: Show header Create Resource Buttons buttons (parent id from parents parameter)
* **Show Status Filter**: Show published/unpublished/deleted dropdown select filter (require Show Deleted and Unpublished - ```YES```)
* **Display Title in title column**: choose which title display in title column: ```pagetitle``` or ```longtitle``` or ```menutitle``` (default :pagetitle)
* **Show Parent Column**: Show Resource Parent Column (and right click context menu)
* **Show User Column**: Show User Column from ```createdby``` or ```publishedby``` or ```editedby``` (default : createdby)
* **Show Date Column**: Show Date Column from ```createdon``` or ```publishedon``` or ```editedon``` (default : editedon)
* **Date Column Format**: Choose date column format: ```DD MM YYYY``` or ```MM DD YYYY``` or ```YYYY MM DD```  (default : DD MM YYYY)
* **Tv column**: The list of tvs to add as sortable columns. example: ```[+longtitle+],[+menuindex+]```
* **Tv Sort type**: Sort mode for tv columns- text(for any text tv)/number(for numbers tv, like price)/date(date is not yet supported). example for longtitle and menuindex: ```text,number```
* **Show Image TV**: enter tv name. ie: ```image```
* **how image Tv in**: choose where show the image thumbnail: ```overview``` row or ```column```
* **Overview Tv Fields**: The list of tvs to add in toogle overview row. example ```[+longtitle+],[+description+],[+introtext+],[+documentTags+]```
* **Overview TV headings**: titles for tvs in overview. example: ```Long Title,Description,Introtext,Tags```
* **Edit docs in modal**: edit and create resources in new evo 1.4 modal window

### Buttons (show/hide) Settings

note: hides the button to everyone, even if the user has permissions
* **Show Move Button**
* **Show Create Resource here Button**
* **Show Publish Button**
* **Show Delete Button**



# To Do

- **Ajax** pagination/load of resources
