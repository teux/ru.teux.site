
var licons = {
        'target': '',  
        'ic_e'  : 'images/0.gif', 
        'ic_l'  : 'images/90.gif',
        'ic_2'  : 'images/91.gif',
        'ic_3'  : 'images/92.gif',
        'ic_4'  : 'images/99.gif',
        'ic_18' : 'images/93.gif',
        'ic_19' : 'images/94.gif',
        'ic_20' : 'images/97.gif',
        'ic_26' : 'images/95.gif',
        'ic_27' : 'images/96.gif',
        'ic_28' : 'images/98.gif'
};

var b_safemode = true;
var trees = [];

get_element = document.all ?
        function (s_id) { return document.all[s_id] } :
        function (s_id) { return document.getElementById(s_id) };


function DHTMLSupported () {
        try {
                var tmp = "";
                tmp = document.body.innerHTML;
                if (tmp.length <= 0) return false;
        } catch(e) {
                return false;
        }
        return true;     
}

function GetIcon (b_junction) {
       if (!b_junction) {
         cur = this.a_prop[2];
         if (this.b_opened) {
           if ((cur == '1') || (cur == '2')) cur = '2';
           if ((cur == '3') || (cur == '4')) cur = '4';
           if ((cur == '5') || (cur == '6')) cur = '6';
           if ((cur == '7') || (cur == '8')) cur = '8';
          };
         if (!this.b_opened) {
           if ((cur == '1') || (cur == '2')) cur = '1';
           if ((cur == '3') || (cur == '4')) cur = '3';
           if ((cur == '5') || (cur == '6')) cur = '5';
           if ((cur == '7') || (cur == '8')) cur = '7';
          };
         return 'files/' + cur + '.gif';
       } else {
         return licons['ic_' + (
           (this.a_childs.length ? 16 : 0) + 
           (this.a_childs.length && this.b_opened ? 8 : 0) + 
           (this.is_last() ? 1 : 0) +
           (this.is_first() ? 2 : 0 ) + 2 ) ];
       }
}

function TreeNode (o_parent, n_order) {

        this.n_depth  = o_parent.n_depth + 1;
        this.a_prop = o_parent.a_prop[n_order + (this.n_depth ? 3 : 0)];
        if (!this.a_prop) return;

        this.o_root    = o_parent.o_root;
        this.o_parent  = o_parent;
        this.n_order   = n_order;
        this.b_opened  = b_safemode;

        this.n_id = this.o_root.a_index.length;
        this.o_root.a_index[this.n_id] = this;
        o_parent.a_childs[n_order] = this;

        this.a_childs = [];
        for (var i = 0; i < this.a_prop.length - 2; i++)
                new TreeNode(this, i);

        this.get_icon = GetIcon;
        this.open     = OIt;
        this.select   = FIt;
        this.init     = IIt;
        this.is_last  = function () { 
           return this.n_order == this.o_parent.a_childs.length - 1 };

        this.is_first  = function () { 
           return (this.n_depth == 0) && (this.n_order == 0) && (!this.is_last())};
 
}
//shrinkTOC added by TEUX
function OIt (b_close, shrinkTOC) {
        var a_childs = [];
        var o_idiv = get_element('divtree' + this.n_id);
        if (!o_idiv) return;
        
        if (b_safemode) {
                document.write(a_childs.join(''));
                for (var i = 0; i < this.a_childs.length; i++) {
                        document.write(this.a_childs[i].init());
                        this.a_childs[i].open();
                }
        } else {
			if (!o_idiv.innerHTML) {
					for (var i = 0; i < this.a_childs.length; i++)
							a_childs[i]= this.a_childs[i].init();
					o_idiv.innerHTML = a_childs.join('');
			}
			o_idiv.style.display = (b_close ? 'none' : 'block');
			this.b_opened = !b_close;
			var o_jicon = document.images['j_img' + this.n_id],
					o_iicon = document.images['i_img' + this.n_id];
			if (o_jicon) o_jicon.src = this.get_icon(true);
			if (o_iicon) o_iicon.src = this.get_icon();
			//by TEUX
			if (!shrinkTOC) expandTOC.apply($('div#ltoc'));
			//alert("EXPAND: " + !shrinkTOC);
        }
		
}

function FIt (b_deselect) {
        if (!b_deselect) {
                var o_olditem = this.o_root.o_selected;
                this.o_root.o_selected = this;
                if (o_olditem) o_olditem.select(true);
		window.pagenum = this.n_id; 
        }
        var o_iicon = document.images['i_img' + this.n_id];
        if (o_iicon) o_iicon.src = this.get_icon();
        get_element('i_txt' + this.n_id).style.fontWeight = b_deselect ? 'normal' : 'bold';
        return Boolean(this.a_prop[1]);
}


function MakeTree (itm, b_openroot) {
        b_safemode = !DHTMLSupported(); this.a_prop = itm; 
        this.o_root = this; this.a_index = []; this.o_selected = null;
        this.n_depth = -1; 
        
        var o_icone = new Image(),
        o_iconl = new Image();
        o_icone.src = licons['ic_e'];
        o_iconl.src = licons['ic_l'];
        licons['im_e'] = o_icone;
        licons['im_l'] = o_iconl;

        for (var i = 0; i < 64; i++)
                if (licons['ic_' + i]) {
                        var o_icon = new Image();
                        licons['im_' + i] = o_icon;
                        o_icon.src = licons['ic_' + i];
                }

        this.select = function (n_id) { return this.a_index[n_id].select(); };
        this.toggle = function (n_id) { var o_item = this.a_index[n_id]; 
           o_item.open(o_item.b_opened) };

        this.a_childs = [];

        var itm = this.a_prop;
        
        for (var i = 0; i < itm.length; i++) {
                new TreeNode(this, i);
        }
        this.n_id = trees.length;
        trees[this.n_id] = this;

        for (var i = 0; i < this.a_childs.length; i++) {
                document.write(this.a_childs[i].init());
                if (b_openroot || b_safemode) this.a_childs[i].open();
        }
        this.OpenTreeNode = OpenTreeNode;
}


function IIt () {
        var a_offset = [],
            o_current_item = this.o_parent;
                             
        for (var i = this.n_depth; i > 0; i--) {
                a_offset[i] = '<img src="' + licons[o_current_item.is_last() ? 'ic_e' : 'ic_l'] + '" border="0" align="absbottom">';
                o_current_item = o_current_item.o_parent;
        }

        return '<a name="#i_txt' + this.n_id + '"></a><table class="ltoc" cellpadding="0" cellspacing="0" border="0"><tr><td>' + 
             a_offset.join('') + (this.a_childs.length ? 
             (b_safemode ? '' : '<a href="javascript: trees[' + this.o_root.n_id + '].toggle(' + this.n_id + 
             ')" >') + '<img src="' + this.get_icon(true) + '" border="0" align="absbottom" name="j_img' + this.n_id + 
             '"/>' + 
             (b_safemode ? '' : '</a>') : '<img src="' + this.get_icon(true) + 
             '" border="0" align="absbottom"/>') + 
             '<a href="' + this.a_prop[1] + 
             '" target="' + licons['target'] + '"' + 
             ' onclick="return trees[' + this.o_root.n_id + '].select(' + this.n_id + ');" ' +
             (b_safemode ? '' : ' ondblclick="trees[' + 
             this.o_root.n_id + '].toggle(' + this.n_id + ')"') + ' class="t0i" id="i_txt' + 
             this.n_id + '">&nbsp;' + 
             this.a_prop[0] + '</a></td></tr></table>' + (this.a_childs.length ? 
             '<div id="divtree' + this.n_id + '" style="display:none"></div>' : '');
}

function OpenTreeNode(filename)
{
        if (this.o_root != null && this.o_root.o_selected != null &&
		this.o_root.o_selected.a_prop[1] == filename) {
		return;
	}

        CheckNode(filename, this);
}

function CheckNode(filename, itm)
{
        for (var i = 0; i < itm.a_childs.length; i++) {
                if (itm.a_childs[i].b_opened)
                        itm.a_childs[i].open(false);
                if (filename == itm.a_childs[i].a_prop[1]) {
                        OpenDownTo(itm.a_childs[i]);
                        itm.a_childs[i].select(false);
						//by TEUX
                        itm.a_childs[i].open(false, true);
                }
                CheckNode(filename, itm.a_childs[i]);
        }
}

function OpenDownTo(node)
{
        if (!node.n_depth)
                return;
        OpenDownTo(node.o_parent);
        node.o_parent.open(false, true);
}

