$PBExportHeader$w_order.srw
forward
global type w_order from window
end type
type dw_search from datawindow within w_order
end type
type cb_close from commandbutton within w_order
end type
type dw_detail from datawindow within w_order
end type
type dw_header from datawindow within w_order
end type
type dw_list from datawindow within w_order
end type
end forward

global type w_order from window
boolean visible = false
integer width = 4069
integer height = 2748
boolean border = false
windowtype windowtype = child!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_search dw_search
cb_close cb_close
dw_detail dw_detail
dw_header dw_header
dw_list dw_list
end type
global w_order w_order

type variables
u_data iu_data
constant string CS_ADDRESS = 'address'
constant string CS_ARTICLE = 'article'
end variables
on w_order.create
this.dw_search=create dw_search
this.cb_close=create cb_close
this.dw_detail=create dw_detail
this.dw_header=create dw_header
this.dw_list=create dw_list
this.Control[]={this.dw_search,&
this.cb_close,&
this.dw_detail,&
this.dw_header,&
this.dw_list}
end on

on w_order.destroy
destroy(this.dw_search)
destroy(this.cb_close)
destroy(this.dw_detail)
destroy(this.dw_header)
destroy(this.dw_list)
end on

event open;long ll_i
datawindowchild ldwc


iu_data = create u_data

dw_header.getchild('address', ldwc)
iu_data.of_fill_address(ldwc)
dw_list.getchild('address', ldwc)
iu_data.of_fill_address(ldwc)

iu_data.of_fill_order(dw_list)

dw_list.sharedata(dw_header)


end event

event resize;dw_list.height = workspaceheight()
dw_header.width = workspacewidth() - dw_header.x
dw_detail.width = workspacewidth() - dw_detail.x
dw_detail.height = workspaceheight() - dw_detail.y

cb_close.x = workspacewidth() - cb_close.width - 4
end event

event close;gw_main.of_close_window('w_order')
end event

type dw_search from datawindow within w_order
event ue_search ( datawindow adw,  dwobject adwo,  string as_data_column,  string as_type,  string as_search )
event ue_set_data ( )
event ue_close ( )
boolean visible = false
integer x = 786
integer y = 1596
integer width = 686
integer height = 400
integer taborder = 40
string title = "none"
string dataobject = "d_search"
boolean vscrollbar = true
boolean livescroll = true
end type

event ue_search(datawindow adw, dwobject adwo, string as_data_column, string as_type, string as_search);u_data lu_data

idw_search = adw
idwo_search = adwo
is_data_search = as_data_column

lu_data = create u_data

// set position (ultra simple solution, many additions should be made like groups in datawindow etc.)
x = long(adw.x) + long(adwo.x)
y = adw.y + adw.getrow() * long(adw.object.datawindow.detail.height) + long(adw.object.datawindow.header.height)
width = long(adwo.width)

// load and filter data
choose case as_type
	case CS_ADDRESS
		lu_data.of_fill_search(dw_search, lu_data.il_address_number, lu_data.is_address_name)
	case CS_ARTICLE
		lu_data.of_fill_search(dw_search, lu_data.il_article_number, lu_data.is_article_description)
end choose

as_search = trim(as_search)
if len(as_search) > 0 then
	// dw_search.setfilter("id like '%" + as_search + "%' or text like '%" + as_search + "%'")
	dw_search.setfilter("string(id) = '" + lower(as_search) + "' or lower(text) like '%" + lower(as_search) + "%'")
	dw_search.filter()
end if
scrolltorow(1)
if not isselected(1) then selectrow(1, true)

visible = true
end event

event ue_set_data();idw_search.setitem(idw_search.getrow(), string(idwo_search.name), string(getitemnumber(getrow(), 'id')) + ' ' + getitemstring(getrow(), 'text'))
idw_search.setitem(idw_search.getrow(), is_data_search, getitemnumber(getrow(), 'id'))
end event

event ue_close();visible = false
end event

event rowfocuschanged;selectrow(0, false)
selectrow(currentrow, true)
end event

type cb_close from commandbutton within w_order
integer x = 2002
integer y = 4
integer width = 142
integer height = 108
integer taborder = 30
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "×"
end type

event clicked;close(parent)
end event

type dw_detail from datawindow within w_order
event ue_key pbm_dwnkey
integer x = 1554
integer y = 428
integer width = 2441
integer height = 2332
integer taborder = 30
string title = "none"
string dataobject = "d_order_detail"
boolean vscrollbar = true
boolean livescroll = true
end type

event ue_key;if dw_search.visible then
	choose case key
		case keydownarrow!
			if dw_search.getrow() < dw_search.rowcount() then
				dw_search.scrolltorow(dw_search.getrow() + 1)
			end if
			return 1
		case keyuparrow!
			if dw_search.getrow() > 1 then
				dw_search.scrolltorow(dw_search.getrow() - 1)
			end if
			return 1
		case keyenter!
			dw_search.event ue_set_data()
			dw_search.event ue_close()
			return 1
		case keyescape!
			dw_search.event ue_close()
			return 1
	end choose
end if
end event

event editchanged;choose case dwo.name
	case 'article_search'
		dw_search.event ue_search(dw_detail, dwo, 'article', CS_ARTICLE, data)
end choose
end event

type dw_header from datawindow within w_order
event ue_key pbm_dwnkey
integer x = 1554
integer width = 2427
integer height = 432
integer taborder = 20
string title = "none"
string dataobject = "d_order_header"
boolean livescroll = true
end type

event ue_key;if dw_search.visible then
	choose case key
		case keydownarrow!
			if dw_search.getrow() < dw_search.rowcount() then
				dw_search.scrolltorow(dw_search.getrow() + 1)
			end if
			return 1
		case keyuparrow!
			if dw_search.getrow() > 1 then
				dw_search.scrolltorow(dw_search.getrow() - 1)
			end if
			return 1
		case keyenter!
			dw_search.event ue_set_data()
			dw_search.event ue_close()
			return 1
		case keyescape!
			dw_search.event ue_close()
			return 1
	end choose
end if
end event

event editchanged;choose case dwo.name
	case 'address_search'
		dw_search.event ue_search(dw_header, dwo, 'address', CS_ADDRESS, data)
end choose
end event

type dw_list from datawindow within w_order
integer width = 1559
integer height = 2752
integer taborder = 10
string title = "none"
string dataobject = "d_orders_list"
boolean vscrollbar = true
boolean livescroll = true
end type

event rowfocuschanged;selectrow(0, false)
selectrow(currentrow, true)

dw_header.scrolltorow(currentrow)

dw_detail.reset()
iu_data.of_fill_order_detail(dw_detail)
end event

