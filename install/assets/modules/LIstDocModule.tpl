/**
 * ListDocModule
 *
 * Documents list/grid
 *
 * @category	module
 * @version     2.0.5
 * @author      Author: Nicola Lambathakis http://www.tattoocms.it/
 * @icon        fa fa-pencil
 * @internal	@modx_category Manager
 * @internal    @properties &modTitle= Module Title:;string;Documents List  &modicon=Module title icon:;string;fa-pencil &ParentFolder=Parent folder for List documents:;string;0 &ListItems=Max items in List:;string;100 &dittolevel=Depht:;string;3 &hideFolders=Hide Folders:;menu;yes,no;no &showUnpublished=Show Deleted and Unpublished:;menu;yes,no;yes;;Show Deleted and Unpublished resources &showAddButtons=Show Create Resource Buttons:;menu;yes,no;no;;show header add buttons &showStatusFilter=Show Status Filter:;menu;yes,no;yes;;require Show Deleted and Unpublished - YES &DisplayTitle=Display Title in title column:;menu;pagetitle,longtitle,menutitle;pagetitle;;choose which title display in title column &showParent=Show Parent Column:;menu;yes,no;yes &showUser=Show User Column:;menu;createdby,publishedby,editedby,no;createdby &showDate=Show Date Column:;menu;createdon,publishedon,editedon,no;editedon &dateFormat=Date Column Format:;menu;DD MM YYYY,MM DD YYYY,YYYY MM DD;DD MM YYYY &TvColumn=Tv Columns:;string;[+longtitle+],[+menuindex+] &TvSortType=Tv Column Sort type:;string;text,number &ImageTv=Show Image TV:;string;image;;enter tv name &ShowImageIn=Show image Tv in:;menu;overview,column;overview &tablefields=Overview Tv Fields:;string;[+longtitle+],[+description+],[+introtext+],[+documentTags+] &tableheading=Overview TV headings:;string;Long Title,Description,Introtext,Tags &editInModal=Edit docs in modal:;menu;yes,no;no;;edit and create resources in evo modal window &showMoveButton=Show Move Button:;menu;yes,no;yes;;hides the button to everyone, even if the user has permissions &showAddHere=Show Create Resource here Button:;menu;yes,no;yes;;hides the button to everyone, even if the user has permissions &showDuplicateButton=Show Duplicate Button:;menu;yes,no;yes;;hides the button to everyone, even if the user has permissions &showPublishButton=Show Publish Button:;menu;yes,no;yes;;hides the button to everyone, even if the user has permissions &showDeleteButton=Show Delete Button:;menu;yes,no;yes;;hides the button to everyone, even if the user has permissions &showEmptyTrashButton=Show Empty Trash Button:;menu;yes,no;yes;;hides the button to everyone, even if the user has permissions &confirmTheme=jquery confirm Theme:;menu;modern,light,dark,supervan,material,bootstrap;modern;;theme styles for confim alert windows
 * @license 	http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 */

if(!defined('MODX_BASE_PATH')){die('What are you doing? Get out of here!');}
//lang
// get global language
global $modx,$_lang,$_style;
//get custom language
$_LDlang = array();
include(MODX_BASE_PATH.'assets/modules/listdoc/lang/english.php');
if (file_exists(MODX_BASE_PATH.'assets/modules/listdoc/lang/' . $modx->config['manager_language'] . '.php')) {
    include(MODX_BASE_PATH.'assets/modules/listdoc/lang/' . $modx->config['manager_language'] . '.php');
}
//config button
$module_id = (!empty($_REQUEST["id"])) ? (int)$_REQUEST["id"] : $yourModuleId;
if($modx->hasPermission('edit_module')) {
$button_config = '<a title="' . $_lang["settings_config"] . '" href="index.php?a=108&id='.$module_id.'" class="btn btn-sm btn-secondary" ><i class="fa fa-cog"></i> ' . $_lang["settings_config"] . '</a>';
}
$manager_theme = $modx->config['manager_theme'];
$confirmTheme = isset($confirmTheme) ? $confirmTheme : 'modern';
//clean languages confirms
$confirm_delete_resource = str_replace(array('\'', '"'), '', $_lang["confirm_delete_resource"]);
$confirm_publish = str_replace(array('\'', '"'), '', $_lang["confirm_publish"]);
$confirm_unpublish = str_replace(array('\'', '"'), '', $_lang["confirm_unpublish"]);
$jsOutput = '

<script src="media/script/jquery/jquery.min.js"></script>
<script src="../assets/modules/listdoc/js/moment.min.js"></script>
<script src="../assets/modules/listdoc/js/footable.min.js"></script>
<script src="../assets/modules/listdoc/js/jquery-confirm.min.js"></script>
<script>
    var mouseX;
    var mouseY;
    $(document).mousemove(function(e) {
       mouseX = e.pageX; 
       mouseY = e.pageY;
    });  
    $(document).bind("mousedown", function (e) {
    // If the clicked element is not the menu
    if (!$(e.target).parents(".context-menu").length > 0) {    
        // Hide it
        $(".context-menu").hide(100);
    }
  });
</script>
<script>
';

if ($showUnpublished == yes) { 
if ($showStatusFilter == yes) { 
$jsOutput .= 'FooTable.MyFiltering = FooTable.Filtering.extend({
	construct: function(instance){
		this._super(instance);
		this.statuses = [\'"' . $_LDlang["published"] . '"\',\'"' . $_LDlang["unpublished"] . '"\',\'"' . $_LDlang["deleted"] . '"\'];
		this.def = \'' . $_LDlang["all_status"] . '\';
		this.$status = null;
	},
	$create: function(){
		this._super();
		var self = this,
			$form_grp = $("<div/>", {"class": "form-group"})
				.append($("<label/>", {"class": "sr-only", text: "Status"}))
				.prependTo(self.$form);
		self.$status = $("<select/>", { "class": "form-control" })
			.on("change", {self: self}, self._onStatusDropdownChanged)
			.append($("<option/>", {text: self.def}))
			.appendTo($form_grp);

		$.each(self.statuses, function(i, status){
			self.$status.append($("<option/>").text(status));
		});
	},
	_onStatusDropdownChanged: function(e){
		var self = e.data.self,
			selected = $(this).val();
		if (selected !== self.def){
			self.addFilter("status", selected, ["status"], false, false, true);
		} else {
			self.removeFilter("status");
		}
		self.filter();
	},
	draw: function(){
		this._super();
		var status = this.find("status");
		if (status instanceof FooTable.Filter){
			this.$status.val(status.query.val());
		} else {
			this.$status.val(this.def);
		}
	}
});
FooTable.components.register("filtering", FooTable.MyFiltering);';
}
}
$jsOutput .= '
jQuery(document).ready(function($){
if($("#treeMenu_emptytrash", window.parent.document).hasClass("disabled")){}
else {
$("#emptyTrash").removeClass("btn-secondary disabled");
$("#emptyTrash").addClass("btn-danger");
}
		$("#TableList").footable({
			"paging": {
				"enabled": true,
				"countFormat": "{CP} ' . $_LDlang["of"] . ' {TP} ' . $_LDlang["pages"] . ' - ' . $_LDlang["total_rows"] . ': {TR}"
			},
			"filtering": {
				"enabled": true
			},
			"sorting": {
				"enabled": true
			},
			components: {
		  filtering: FooTable.MyFiltering
	        }
		});
$("[data-page-size]").on("click", function(e){
	e.preventDefault();
	var newSize = $(this).data("pageSize");
	FooTable.get("#TableList").pageSize(newSize);
});
 var ActiveID;
    var activeSizeButton = localStorage.getItem("DashboardList'.$pluginid.'_active_btn");
    if (activeSizeButton) {
        ActiveID = activeSizeButton;
        $(ActiveID).addClass("active");
    }
$("button.btn-size").each(function(){
    $(this).click(function(){
        $(this).siblings().removeClass("active"); 
        $(this).toggleClass("active");
        localStorage.setItem("DashboardList'.$pluginid.'_active_btn", "#" + $(this).attr("id"));
        $(this).addClass("active");
    });
});


$("#TableList").on("click", ".btn-delete" , function(){
event.preventDefault();
event.stopPropagation();
 trID = $(this).closest("tr").attr("id");
$.confirm({
	escapeKey: \'cancel\',
    type: \'red\',
    theme: \''.$confirmTheme.'\',
    animateFromElement: false,
	useBootstrap: false,
    animation: \'top\',
    closeAnimation: \'scale\',
	icon: \'fa fa-question\',
    title: \'' . $_lang["delete_resource"] . ' \'+trID,
    content: \'' . $confirm_delete_resource . '\',
    buttons: {	
        confirm: {
        btnClass: \'btn-danger\',
		text: \'' . $_lang["yes"] . '\',
		action: function () {
		    result= true;
			if(confirm) {
			var jqxhr = $.post( "index.php?a=6&id="+trID, function() {
            parent.window.location.reload(true);	
               })			  
            }
			 $.alert({			 
			 useBootstrap: false,
			 animateFromElement: false,
			 type: \'green\',
    		 animation: \'top\',
			 theme: \''.$confirmTheme.'\',
			 icon: \'fa fa-thumbs-o-up\',
			 title:\'' . $_LDlang["deleted"] . ' \'+trID,
			 content: \'' . $_lang["actioncomplete"] . '\',
			 useBootstrap: false,
    		 animation: \'top\',
			 });
			} 
        },
        cancel: {
		btnClass: \'btn-warning\',
		text: \'' . $_lang["cancel"] . '\',
		action: function () {
           //$.alert(\'Canceled!\');
        }
		 }
    }
});
});

$("#TableList").on("click", ".btn-undelete" , function(){
event.preventDefault();
event.stopPropagation();
 trID = $(this).closest("tr").attr("id");
$.confirm({
	escapeKey: \'cancel\',
    type: \'orange\',
    theme: \''.$confirmTheme.'\',
    animateFromElement: false,
	useBootstrap: false,
    animation: \'top\',
    closeAnimation: \'scale\',
	icon: \'fa fa-question\',
    title: \'' . $_lang["undelete_resource"] . ' \'+trID,
    content: \'' . $_lang["confirm_undelete"] . '\',
    buttons: {	
        confirm: {
		btnClass: \'btn-success\',
		text: \'' . $_lang["yes"] . '\',
		action: function () {
		    result= true;
			if(confirm) {
			var jqxhr = $.post( "index.php?a=63&id="+trID, function() {
            parent.window.location.reload(true);	
               })			  
            }			
			 $.alert({			 
			 useBootstrap: false,
			 animateFromElement: false,
			 type: \'green\',
    		 animation: \'top\',
			 theme: \''.$confirmTheme.'\',
			 icon: \'fa fa-thumbs-o-up\',
			 title:\'' . $_lang["undeleted"] . ' \'+trID,
			 content: \'' . $_lang["actioncomplete"] . '\',
			 useBootstrap: false,
    		 animation: \'top\',
			 });
			} 
        },
        cancel: {
		btnClass: \'btn-warning\',
		text: \'' . $_lang["cancel"] . '\',
		action: function () {
           //$.alert(\'Canceled!\');
        }
		 }
    }
});
});

$("#TableList").on("click", ".btn-unpublish" , function(){
event.preventDefault();
event.stopPropagation();
 trID = $(this).closest("tr").attr("id");
$.confirm({
	escapeKey: \'cancel\',
    type: \'orange\',
    theme: \''.$confirmTheme.'\',
    animateFromElement: false,
	useBootstrap: false,
    animation: \'top\',
    closeAnimation: \'scale\',
	icon: \'fa fa-question\',
    title: \'' . $_lang["unpublish_resource"] . ' \'+trID,
    content: \'' . $confirm_unpublish . '\',
    buttons: {	
        confirm: {
		btnClass: \'btn-success\',
		text: \'' . $_lang["yes"] . '\',
		action: function () {
		    result= true;
			if(confirm) {
			var jqxhr = $.post( "index.php?a=62&id="+trID, function() {
			window.location.reload(true);
               })			  
            }
			 $.alert({			 
			 useBootstrap: false,
			 animateFromElement: false,
			 type: \'green\',
    		 animation: \'top\',
			 theme: \''.$confirmTheme.'\',
			 icon: \'fa fa-thumbs-o-up\',
			 title:\'' . $_lang["unpublish_resource"] . ' \'+trID,
			 content: \'' . $_lang["actioncomplete"] . '\',
			 useBootstrap: false,
    		 animation: \'top\',
			 });
			} 
        },
        cancel: {
		btnClass: \'btn-warning\',
		text: \'' . $_lang["cancel"] . '\',
		action: function () {
           //$.alert(\'Canceled!\');
        }
		 }
    }
});
});

$("#TableList").on("click", ".btn-publish" , function(){
event.preventDefault();
event.stopPropagation();
 trID = $(this).closest("tr").attr("id");
$.confirm({
	escapeKey: \'cancel\',
    type: \'orange\',
    theme: \''.$confirmTheme.'\',
    animateFromElement: false,
	useBootstrap: false,
    animation: \'top\',
    closeAnimation: \'scale\',
	icon: \'fa fa-question\',
    title: \'' . $_lang["publish_resource"] . ' \'+trID,
    content: \'' . $confirm_publish . '\',
    buttons: {	
        confirm: {
		btnClass: \'btn-success\',
		text: \'' . $_lang["yes"] . '\',
		action: function () {
		    result= true;
			if(confirm) {
			var jqxhr = $.post( "index.php?a=61&id="+trID, function() {
			window.location.reload(true);
               })			  
            }
			 $.alert({			 
			 useBootstrap: false,
			 animateFromElement: false,
			 type: \'green\',
    		 animation: \'top\',
			 theme: \''.$confirmTheme.'\',
			 icon: \'fa fa-thumbs-o-up\',
			 title:\'' . $_lang["publish_resource"] . ' \'+trID,
			 content: \'' . $_lang["actioncomplete"] . '\',
			 useBootstrap: false,
    		 animation: \'top\',
			 });
			} 
        },
        cancel: {
		btnClass: \'btn-warning\',
		text: \'' . $_lang["cancel"] . '\',
		action: function () {
           //$.alert(\'Canceled!\');
        }
		 }
    }
});
});
$("#TableList").on("click", ".btn-duplicate" , function(event){
event.preventDefault();
event.stopPropagation();
 trID = $(this).closest("tr").attr("id");
$.confirm({
	escapeKey: \'cancel\',
    type: \'orange\',
    theme: \''.$confirmTheme.'\',
    animateFromElement: false,
	useBootstrap: false,
    animation: \'top\',
    closeAnimation: \'scale\',
	icon: \'fa fa-question\',
    title: \'' . $_lang["resource_duplicate"] . ' \'+trID,
    content: \'' . $_lang["confirm_duplicate_record"] . '\',
    buttons: {	
        confirm: {
		btnClass: \'btn-success\',
		text: \'' . $_lang["yes"] . '\',
		action: function () {
		    result= true;				
			if(confirm) {
			var jqxhr = $.post( "index.php?a=94&id="+trID, function() {
			window.location.reload(true);
               })
            }			 
			 $.alert({			 
			 useBootstrap: false,
			 animateFromElement: false,
			 type: \'green\',
    		 animation: \'top\',
			 theme: \''.$confirmTheme.'\',
			 title:\'' . $_lang["resource_duplicate"] . ' \'+trID,
			 content: \'' . $_lang["actioncomplete"] . '\',
			 useBootstrap: false,
    		 animation: \'top\',
			 });
			} 
        },
        cancel: {
		btnClass: \'btn-warning\',
		text: \'' . $_lang["cancel"] . '\',
		action: function () {
           //$.alert(\'Canceled!\');
        }
		 }
    }
});
});

$("#emptyTrash").confirm({
	escapeKey: \'cancel\',
    type: \'red\',
    theme: \''.$confirmTheme.'\',
    animateFromElement: false,
	useBootstrap: false,
    animation: \'top\',
    closeAnimation: \'scale\',
	icon: \'fa fa-warning\',
    title: \'' . $_lang["empty_recycle_bin"] . '<br/><br/>' . $_lang["are_you_sure"] . '\',
    content: \'' . $_lang["confirm_empty_trash"] . '\',
    buttons: {
        confirm: {
		btnClass: \'btn-danger\',
		text: \'' . $_lang["yes"] . '\',
		action: function () {            
			result= true;
			location.href = href="index.php?a=64";
			 parent.location.reload();	
			 $.alert({
			 useBootstrap: false,
			 type: \'green\',
    		 animation: \'top\',
			 theme: \''.$confirmTheme.'\',
			 title:\'' . $_lang["empty_recycle_bin"] . ' \',
			 content: \'' . $_lang["actioncomplete"] . '\',
			 useBootstrap: false,
    		 animation: \'top\',
			 });
			}
        },
        cancel: {
		btnClass: \'btn-info\',
		text: \'' . $_lang["cancel"] . '\',
		action: function () {
           //$.alert(\'Canceled!\');
        }
	
    }
    }
});
$("div#DashboardList").fadeIn();
});

</script>';
if($manager_theme == "EvoFLAT") {
$cssOutput = '
<link type="text/css" rel="stylesheet" href="media/style/' . $modx->config['manager_theme'] . '/style.css">
<link type="text/css" rel="stylesheet" href="../assets/modules/listdoc/css/footable.evo.min.css">
<link type="text/css" rel="stylesheet" href="../assets/modules/listdoc/css/list_flat.css">
<link type="text/css" rel="stylesheet" href="../assets/modules/listdoc/css/jquery-confirm.min.css">';
}
else {
$cssOutput = '
<link type="text/css" rel="stylesheet" href="media/style/' . $modx->config['manager_theme'] . '/style.css">
<link type="text/css" rel="stylesheet" href="../assets/modules/listdoc/css/footable.evo.min.css">
<link type="text/css" rel="stylesheet" href="../assets/modules/listdoc/css/list.css">';
}

//output
$WidgetOutput = isset($WidgetOutput) ? $WidgetOutput : '';
$TvColumn = isset($TvColumn) ? $TvColumn : '';
$tablefields = isset($tablefields) ? $tablefields : '[+longtitle+],[+description+],[+introtext+],[+documentTags+]';
$tableheading = isset($tableheading) ? $tableheading : 'Long Title,Description,Introtext,Tags';
		
//Header create resource in parent buttons
if ($showAddButtons == yes) { 
	if($modx->hasPermission('edit_document')) {	
$Parents = explode(",","$ParentFolder");
foreach ($Parents as $Parent){
	if ($Parent != '0') {
	$ParentT = $modx->getPageInfo($Parent,'*','pagetitle');
	$ParentTitle = $ParentT['pagetitle'];
	}
	else {	
	$ParentTitle = "<i class=\"fa fa-sitemap\"></i> Root";}
	if ($editInModal == yes) {
	$ParentsButtons .= '<a class="btn btn-sm btn-success" title="' . $_lang["create_resource_here"] . '" style="cursor:pointer" href="" onClick="parent.modx.popup({url:\''. MODX_MANAGER_URL.'?a=4&pid='.$Parent.'\',title1:\'' . $_lang["create_resource_here"] . '\',icon:\'fa-file-o\',iframe:\'iframe\',selector2:\'.tab-page>.container\',position:\'center center\',width:\'80%\',height:\'80%\',wrap:\'body\',hide:0,hover:0,overlay:1,overlayclose:1})">+ <i class="fa fa-file-o fa-fw"></i>  ' . $ParentTitle . '</a> ';
	}
	else {
    $ParentsButtons .=  "
	<a target=\"main\" href=\"index.php?a=4&pid=$Parent\" title=\"" . $_lang["create_resource_here"] . "\" class=\"btn btn-sm btn-success\">+ <i class=\"fa fa-file-o fa-fw\"></i> " . $ParentTitle . " </a>
    ";
	}
	}
}
}		
//get Tv vars Heading Titles from Module configuration (ie: Page Title,Description,Date)
$tharr = explode(",","$tableheading");
$tdarr = explode(",","$tablefields");
foreach (array_combine($tharr, $tdarr) as $thval => $tdval){
    $thtdfields .=  "
    <li><b>" . $thval . "</b>: " . $tdval . "</li>
    ";
}
//get tv columns
$TvColumns = explode(",","$TvColumn");
$TvTypes = explode(",","$TvSortType");
foreach (array_combine($TvColumns, $TvTypes) as $TvTD => $TvType){
    $TvTDs .=  '<td aria-expanded="false" class="footable-toggle">'.$TvTD.'</td>';
	$find = array('[+','+]');
	$replace = array('','');
	$getTvName = str_replace($find,$replace,$TvTD);
	$TvName = $getTvName;
	$TvColumnsHeaders .= '<th data-breakpoints="xs" data-type="'.$TvType.'">'.$TvName.'</th> ';
}
//get date format 
$dateFormat = isset($dateFormat) ? $dateFormat : 'DD MM YYYY';
$find = array('DD','MM','YYYY');
$replace = array('%d','%m','%Y');
$DLdate = str_replace($find,$replace,$dateFormat);
		
////////////Columns
//ID column	
$rowTpl = '@CODE: <tr id="[+id+]">
<td aria-expanded="false" class="footable-toggle"> <span class="label label-info">[+id+]</span></td> ';
		
//Image column	
if ($ImageTv != '') {
if ($ShowImageIn == column) {
$rowTpl .= '<td aria-expanded="false" class="footable-toggle" ><img class="footable-toggle img-thumbnail-sm" src="../[[phpthumb? &input=`[+'.$ImageTv.'+]` &options=`w=70,h=70,q=60,zc=C`]]" alt="[+title+]"> </td> ';
$ImageTVHead = '<th width="100" data-type="html" data-breakpoints="xs" data-filterable="false" data-sortable="false" style="text-align:center"><i class="icon-imagetv fa fa-2x fa-camera" aria-hidden="true"></i></th> ';
}
}
//Title column		
$rowTpl .= '<td class="footable-toggle"><a target="main" data-title="edit?" class="dataConfirm [[if? &is=`[+published+]:=:0` &then=`unpublished`]] [[if? &is=`[+deleted+]:=:1` &then=`deleted`]] [[if? &is=`[+hidemenu+]:is:1:and:[+published+]:is:1` &then=`notinmenu`]]" href="index.php?a=27&id=[+id+]" title="' . $_lang["edit_resource"] . '">[[if? &is=`[+'.$DisplayTitle.'+]:!empty` &then=`[+'.$DisplayTitle.'+]` &else=[+title+]`]]</a>[[if? &is=`[+type+]:is:reference` &then=` <i class="weblinkicon fa fa-link"></i>`]]</td> ';	

//Parent column	and context menu	
if ($showParent == yes) {
$rowTpl .= '
<td aria-expanded="false" [[if? &is=`[+parent+]:not:0`&then=`oncontextmenu ="event.preventDefault();$(\'#[+id+]context-menu\').show();$(\'#context-menu\').offset({\'top\':mouseY,\'left\':mouseX})"`]]> 
[[if? &is=`[+parent+]:not:0`&then=`<a target="main" href="index.php?a=3&id=[+parent+]&tab=1" title="'.$_lang["view_child_resources_in_container"].'">[[DocInfo? &docid=`[+parent+]` &field=`pagetitle`]]</a>`]]
<div class="context-menu" id="[+id+]context-menu" style="display:none;z-index:99">
    <ul>
	<li class="parentname">[[DocInfo? &docid=`[+parent+]` &field=`pagetitle`]]</li>
      <li><a target="main" href="index.php?a=3&id=[+parent+]&tab=1"><i class="fa fa-list fa-fw"></i>  '.$_lang["view_child_resources_in_container"].'</a></li>';	
if($modx->hasPermission('edit_document')) {	
$rowTpl .= '<li><a target="main" href="index.php?a=27&id=[+parent+]"><i class="fa fa-pencil-square-o fa-fw"></i>  ' . $_lang["edit_resource"] . '</a></li>
			<li><a target="main" href="index.php?a=4&pid=[+parent+]"><i class="fa fa-file-o fa-fw"></i>  ' . $_lang["create_resource_here"] . '</a></li> 
			<li><a target="main" href="index.php?a=72&pid=[+parent+]"><i class="fa fa-link fa-fw"></i>  ' . $_lang["create_weblink_here"] . '</a></li>
	        <li><a target="main" href="index.php?a=56&id=[+parent+]"><i class="fa fa-sort-numeric-asc fa-fw"></i>  ' . $_lang["sort_menuindex"] . '</a></li>';
}
$rowTpl .= '<li><a href="[(site_url)]index.php?id=[+parent+]" target="_blank" title="' . $_lang["preview_resource"] . '"><i class="fa fa-eye""></i>  '.$_lang["preview_resource"].'</a></li></td></ul></div>';
}
//TVs columns		
$rowTpl .= $TvTDs;
		
//Status column	(hidden)	
$rowTpl .= '
<td aria-expanded="false" class="footable-toggle"> 
 [[if? &is=`[+deleted+]:=:1` &then=`' . $_LDlang["deleted"] . '` &else=`[[if? &is=`[+published+]:=:1` &then=`' . $_LDlang["published"] . '` &else=`' . $_LDlang["unpublished"] . '`]]`]] 
</td>';	

//DATE column
if ($showDate == 'createdon') { 
$rowTpl .= '<td style="white-space: nowrap;" class="footable-toggle text-nowrap">[+createdon:date=`' . $DLdate . '`+]</td>';
$dateColHead = '<th data-type="date" data-format-string="'.$dateFormat.'" data-sorted="true" data-direction="DESC" style="width: 1%; text-align:right;">' . $_lang["page_data_created"] . '</th>';
}
else if ($showDate == 'publishedon') { 
$rowTpl .= '<td style="white-space: nowrap;" class="footable-toggle text-nowrap">[+publishedon:date=`' . $DLdate . '`+]</td>';
$dateColHead = '<th data-type="date" data-format-string="'.$dateFormat.'" data-sorted="true" data-direction="DESC" style="width: 1%; text-align:right;">' . $_lang["page_data_published"] . '</th>';
}
else if ($showDate == 'editedon') { 
$rowTpl .= '<td style="white-space: nowrap;" class="footable-toggle text-nowrap">[+editedon:date=`' . $DLdate . '`+]</td>';
$dateColHead = '<th data-type="date" data-format-string="'.$dateFormat.'" data-sorted="true" data-direction="DESC" style="width: 1%; text-align:right;">' . $_lang["page_data_edited"] . '</th>';
}
else {}	

//USER column
if ($showUser == 'createdby') { 
$rowTpl .= '<td style="white-space: nowrap" class="footable-toggle text-nowrap">[+user.username.createdby+]</td>';
$userColHead = '<th data-type="text">' . $_lang["user"] . '</th>';
}
else if ($showUser == 'publishedby') { 
$rowTpl .= '<td style="white-space: nowrap" class="footable-toggle text-nowrap">[+user.username.publishedby+]</td>';
$userColHead = '<th data-type="text">' . $_lang["user"] . '</th>';
}
else if ($showUser == 'editedby') { 
$rowTpl .= '<td style="white-space: nowrap" class="footable-toggle text-nowrap">[+user.username.editedby+]</td>';
$userColHead = '<th data-type="text">' . $_lang["user"] . '</th>';
}
else {}	
		
$rowTpl .='<td style="text-align: right;" class="actions">';	
//Action buttons 
if($modx->hasPermission('edit_document')) {		
if ($editInModal == yes) {
$rowTpl .= '<a title="' . $_lang["edit_resource"] . '" style="cursor:pointer" href="" onClick="parent.modx.popup({url:\''. MODX_MANAGER_URL.'?a=27&id=[+id+]&tab=1\',title1:\'' . $_lang["edit_resource"] . '\',icon:\'fa-pencil-square-o\',iframe:\'iframe\',selector2:\'.tab-page>.container\',position:\'center center\',width:\'80%\',height:\'80%\',wrap:\'body\',hide:0,hover:0,overlay:1,overlayclose:1})"><i class="fa fa-external-link"></i></a>';
}
else {
$rowTpl .= '<a target="main" href="index.php?a=27&id=[+id+]" title="' . $_lang["edit_resource"] . '"><i class="fa fa-pencil-square-o"></i></a>';
}
}		
$rowTpl .= '<a href="[(site_url)]index.php?id=[+id+]" target="_blank" title="' . $_lang["preview_resource"] . '"><i class="fa fa-eye"></i></a> ';
if($modx->hasPermission('edit_document')) {	
if ($showMoveButton == yes) { 
$rowTpl .= '<a class="hidden-xs-down" target="main" href="index.php?a=51&id=[+id+]" title="' . $_lang["move_resource"] . '"><i class="fa fa-arrows"></i></a> ';
}

//Duplicate btn href="index.php?a=94&id=[+id+]" 
if ($showDuplicateButton == yes) { 
$rowTpl .= '<a class="btn-duplicate hidden-xs-down" target="main" href="index.php?a=94&id=[+id+]" title="' . $_lang["resource_duplicate"] . '"><i class="fa fa-clone"></i></a> ';
}	
//Publish btn	
if ($showPublishButton == yes) { 
$rowTpl .= '[[if? &is=`[+deleted+]:=:0` &then=`[[if? &is=`[+published+]:=:1` &then=` 
<a class="btn-unpublish hidden-xs-down" target="main" href="index.php?a=62&id=[+id+]" title="' . $_lang["unpublish_resource"] . '"><i class="fa fa-arrow-down"></i></a>  
`&else=`
<a class="btn-publish hidden-xs-down" target="main" href="index.php?a=61&id=[+id+]" title="' . $_lang["publish_resource"] . '"><i class="fa fa-arrow-up"></i></a>  
`]]
`&else=`
<span style="opacity:0;" class="hidden-xs-down text-muted" title="publish"><i class="fa fa-arrow-up"></i></span>  
`]]
';
}
}
//add resource here btn
if ($showAddHere == yes) { 
if ($editInModal == yes) {
$rowTpl .= '<a class="hidden-xs-down" title="' . $_lang["create_resource_here"] . '" style="cursor:pointer" href="" onClick="parent.modx.popup({url:\''. MODX_MANAGER_URL.'?a=4&pid=[+id+]\',title1:\'' . $_lang["create_resource_here"] . '\',icon:\'fa-file-o\',iframe:\'iframe\',selector2:\'.tab-page>.container\',position:\'center center\',width:\'80%\',height:\'80%\',wrap:\'body\',hide:0,hover:0,overlay:1,overlayclose:1})"><i class="fa fa-file-o"></i></a>';
}
else {
$rowTpl .= '<a class="hidden-xs-down" target="main" href="index.php?a=4&pid=[+id+]" title="' . $_lang["create_resource_here"] . '"><i class="fa fa-file-o"></i></a> ';
}
}
//delete btn
if ($showDeleteButton == yes) { 
if($modx->hasPermission('delete_document')) {
$rowTpl .= '[[if? &is=`[+deleted+]:=:0` &then=` 
<a class="btn-delete" href="index.php?a=6&id=[+id+]" target="main" onclick="return false;" title="' . $_lang["delete_resource"] . '""><i class="fa fa-trash"></i></a>  
`&else=`
<a class="btn-undelete" target="main" href="index.php?a=63&id=[+id+]" title="' . $_lang["undelete_resource"] . '"><i class="fa fa-arrow-circle-o-up"></i></a>  
`]]';
}
}
//overview btn		
$rowTpl .= '<span class="footable-toggle" style="margin-left:-4px;" title="' . $_lang["resource_overview"] . '"><i class="footable-toggle fa fa-info"></i></span></td>

<td class="resource-details">';
//image tv			
if ($ImageTv != '') {
if ($ShowImageIn == overview) {
$rowTpl .= '<div class="pull-left" style="margin-right:5px"><img class="img-responsive img-thumbnail" src="../[[phpthumb? &input=`[+'.$ImageTv.'+]` &options=`w=90,h=90,q=60,zc=C`]]" alt="[+title+]"> </div> ';
}
}
$rowTpl .= '
<div class="text-small">
<ul>
'.$thtdfields.'
</ul>
</div>
</td>
</tr>
';
//headers		
if ($showParent == yes) {
$parentColumnHeader = '
<th data-type="text">' . $_lang["resource_parent"] . '</th> ';
}
$ImageTV = isset($ImageTV) ? $ImageTV : '';

//DocListerTvs
$find = array('[+','+]');
$replace = array('','');
$DocListerTvs = str_replace($find,$replace,$tablefields);
$DocListerTvFields = $DocListerTvs;
//DocListerTvs
$findtv = array('[+','+]');
$replacetv = array('','');
$TvColumnList = str_replace($find,$replace,$TvColumn);
if ($TvColumn != '') {
$TvFields = ''.$ImageTv.','.$DocListerTvFields.','.$TvColumnList.'';
$TvColumnHeader = '
<th data-type="text">'.$TvColumn.'</th> ';
}
else {
$TvFields = ''.$ImageTv.','.$DocListerTvFields.'';
}
$parentId = $ParentFolder;
// DocLister parameters
$params['debug'] = '0';	//enable to debug listing
$params['id'] = 'doclistwdg';
$params['parents'] = $parentId;
$params['depth'] = $dittolevel;
$params['filters'] = 'private';
$params['tpl'] = $rowTpl;
$params['tvPrefix'] = '';
$params['tvList'] = $TvFields;
$params['display'] = $ListItems;
//filters
if ($showUnpublished == yes) {
$params['showNoPublish'] = '1';
}
if ($hideFolders == yes) {
$wherehideFolders = 'isfolder=0';
$params['addWhereList'] = 'isfolder=0';
}
//user extender
$params['extender'] = 'user';
$params['usertype'] = 'mgr';
$params['userFields'] = 'createdby,publishedby,editedby';

// run DocLister
$list = $modx->runSnippet('DocLister', $params);

//out module
$output ='';

$output .= ''.$jsOutput.'';
					
// onManagerMainFrameHeaderHTMLBlock
$evtOut = $modx->invokeEvent('OnManagerMainFrameHeaderHTMLBlock');
$onManagerMainFrameHeaderHTMLBlock = is_array($evtOut) ? implode("\n", $evtOut) : '';
$output .= $onManagerMainFrameHeaderHTMLBlock;
																	 
$output .= '
'.$cssOutput.'
<style>
.footable {font-size:1em}
.footable .text-small  {font-size:0.84em}
.footable .btn .caret {
	margin-left: 0;
	display:none /*flat fix*/
}
.footable .input-group .btn-primary {
	padding:9px 12px;
}
.footable .input-group .btn-secondary {
	padding:13px 12px;
}
.btn-refresh {
	padding:7px 10px 6px 10px;
}
</style>

<h1>
	<i class="fa '.$modicon.'"></i>'.$modTitle.'
</h1>
<div class="buttonConfig" style="position:absolute;top:25px;right:25px;z-index:10;">
'.$button_config.'
</div>
<div class="tab-page">
<div style="display:none;" id="DashboardList" class="table-responsive">
				<table data-state="true" data-state-key="ListDocMod_state" data-paging-size="10" data-show-toggle="false" data-toggle-column="last" data-toggle-selector=".footable-toggle" data-filter-ignore-case="true" data-filtering="true" data-state-filtering="true" data-filter-exact-match="false" data-filter-dropdown-title="'.$_lang["search_criteria"].'" data-filter-placeholder="'.$_lang["element_filter_msg"].'" data-filter-position="right" class="table data" id="TableList">
                <thead>
<div style="position:absolute;top:75px;left:25px;z-index:10;" class="hidden-xs-down">
<button type="button" class="btn btn-sm btn-success btn-refresh" onClick="window.location.reload();" title="' . $_LDlang["update"] . '"><i class="fa fa-refresh" aria-hidden="true"></i></button>
<button type="button" class="btn btn-sm btn-secondary btn-size" id="page-size-5" data-page-size="5">5</button>
<button type="button" class="btn btn-sm btn-secondary btn-size" id="page-size-10" data-page-size="10">10</button>
<button type="button" class="btn btn-sm btn-secondary btn-size" id="page-size-25" data-page-size="25">25</button>
<button type="button" class="btn btn-sm btn-secondary btn-size" id="page-size-50" data-page-size="50">50</button>
<button type="button" class="btn btn-sm btn-secondary btn-size" id="page-size-75" data-page-size="75">75</button>
<button type="button" class="btn btn-sm btn-secondary btn-size" id="page-size-100" data-page-size="100">100</button>
<div style="display:inline-block;margin-left:15px">'.$ParentsButtons.'</div>
</div>
						<tr>
							<th data-type="number" style="width: 1%">'.$_lang["id"].'</th>
							'.$ImageTVHead.'
							<th data-type="text">'.$_lang["resource_title"].'</th>
							
							'.$parentColumnHeader.'							
							'.$TvColumnsHeaders.'
							<th data-visible="false" data-name="status" data-filterable="true" data-type="text">'.$_lang["page_data_status"].'</th>
							'.$dateColHead.'
							'.$userColHead.'						
							<th data-filterable="false" data-sortable="false" style="width: 1%; text-align:center;">'.$_lang["mgrlog_action"].'</th>
							<th data-filterable="false" data-sortable="false" data-breakpoints="all"></th>
						</tr>
					</thead>                    <tbody>
'.$list.' 
</tbody></table>
</div>';
if ($showEmptyTrashButton == yes) { 
if($modx->hasPermission('empty_trash')) {
$output .= '
<div id="purgeTrash" style="margin-top:10px;margin-right:30px;" class="pull-right">
<a id="emptyTrash" class="btn btn-md btn-emptytrash btn-secondary disabled" data-title="' . $_lang["empty_recycle_bin"] . '?" href="index.php?a=64" title="' . $_lang["empty_recycle_bin"] . '">'.$_style['empty_recycle_bin_empty'].'</a>
';
}
}
$output .= '</div>
</div>';

return $output;