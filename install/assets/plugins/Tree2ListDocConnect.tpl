/**
 * Tree2ListDocConnect
 *
 * Open ListDoc Module on tree resource click, hide child documents and change the icon 
 *
 * @category	plugin
 * @version     0.1
 * @author      Author: Nicola Lambathakis http://www.tattoocms.it/
 * @internal	@modx_category Manager
 * @internal    @events OnManagerNodePrerender
 * @internal    @properties &ListDocModID=ListDoc Module ID:;string;18 &ListDocResourceID=Resource ID (folder) connected to ListDoc Module:;string;2 &ResourceIcon=Custom resource icon:;string;fa fa-bars;;optional &ResourceIconFolder=Custom resource folder icon:;string;fa fa-bars;;optional &ResourceIconFolderOpen=Custom resource folder open icon:;string;fa fa-bars;;optional
 * @license 	http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 * @internal    @installset base
 * @internal    @disabled 1
 */


// TreeListDoc is based on TreeCollections
//&ListDocModID=ListDoc Module ID:;string;18 &ListDocResourceID=Resource ID (folder) connected to ListDoc Module:;string;2 &ResourceIcon=Custom resource icon:;string;fa fa-bars;;optional &ResourceIconFolder=Custom resource folder icon:;string;fa fa-bars;;optional &ResourceIconFolderOpen=Custom resource folder open icon:;string;fa fa-bars;;optional

$ResourceIcon = isset($ResourceIcon) ? $ResourceIcon : 'fa fa-bars';
$ResourceIconFolder = isset($ResourceIconFolder) ? $ResourceIconFolder : 'fa fa-bars';
$ResourceIconFolderOpen = isset($ResourceIconFolderOpen) ? $ResourceIconFolderOpen : 'fa fa-bars';

$e = &$modx->Event;
switch($e->name){
	case 'OnManagerNodePrerender':
		//if($_SESSION['mgrRole']!=='2') return;
		//if($_SESSION['mgrShortname']!=='admin') return;
		if($ph['id'] == $ListDocResourceID){
		    $ph['icon'] = "<i class='$ResourceIcon'></i>";
		    $ph['icon_folder_open'] = "<i class='$ResourceIconFolderOpen'></i>";
		    $ph['icon_folder_close'] = "<i class='$ResourceIconFolder'></i>";
			$ph['showChildren'] = '0';
			$ph['tree_page_click'] = 'index.php?a=112&id='.$ListDocModID.'';
		}
		$e->output(serialize($ph));
		break;
}