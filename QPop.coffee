$ = jQuery
window = $ @
document = $ document
body = $ 'body'
IE6 = not -[1,] and not window.XMLHttpRequest
getPostype = ->
	`IE6 ? 'absolute' : 'fixed'`

# 获取页面高度			
getFullHeight = ->
	if window.height() > body.height()
		return window.height()
	return body.height()
	
# class
Pop = (target, opts) ->
	@target = target
	@settings = opts;
	@timer = null

	@init()
	return

Pop:: = 
	# 初始化
	init: ->
		that = @
		opts = that.settings
		that.closePrevPop();
		opts.beforeCallback that

		if opts.isColseBtn 
			that.createClose()

		if opts.isLock
			that.createLock()

		if typeof opts.time is 'number' 
			that.timer = setTimeout ->
				that.closePop()
				return
			, opts.time

		that.bindEvent();
		that.showTarget();
		return

	# 显示弹出层
	showTarget: ->
		that = @
		obj = that.target
		opts = that.settings

		obj.addClass('prevPopBox').show()

		# 如果是居中
		if opts.middile
			left = Math.round (body.width() - obj.outerWidth())/2
			top = Math.round (window.height() - obj.outerHeight())/2
			obj.css
				'position': getPostype(),
				'left': left,
				'top': top,
				'z-index': opts.zIndex + 1
		# TODO: 可以增加元素位置显示
		return
	# 创建锁屏
	createLock: ->
		that = @
		opts = that.settings
		popLock =  $('#QpopLock')
		if popLock.length > 0
			popLock.show()
			return
		popLock = that.Lock = $ '<div id="QpopLock"></div>'
		popLock.css 
			'position': 'absolute'
			'top':0
			'left':0
			'width': '100%'
			'height': '100%'
			'background-color': opts.lockBgColor
			'opacity': opts.opacity
			'z-index': opts.zIndex
		# fixed ie6 bug
		if IE6
			that.createIframe popLock

		body.append popLock
		return
		
	# iframe遮罩层
	createIframe: (elem) ->
		elem.html '<iframe style="position:absolute;left:0;top:0;width:100%;height:100%;z-index:-1;border:0 none;filter:alpha(opacity=0)"></iframe>'
		return

	# 关闭按钮
	createClose: ->
		closeBtn = @closeBtn = $ '<a class="popCloseBtn">关闭</a>'
		@target.append closeBtn
		return

	# 事件绑定
	bindEvent: ->
		that = @
		# 是否绑定close事件
		if that.closeBtn
			that.closeBtn.bind 'click', ->
				that.closePop()
				return
		# 是否绑定锁屏关闭事件
		if that.Lock and that.lockColse
			that.Lock.bind 'click', ->
				that.closePop()
				return
		return


	# 锁屏关闭事件
	closePop: ->
		that = @

		clearTimeout that.timer

		if that.Lock
			that.Lock.remove()
		if that.closeBtn
			that.closeBtn.remove()
		that.target.removeClass('prevPopBox').hide()
		that.settings.colseCallback.call that
		return

	# 
	closePrevPop: ->
		body.find('.prevPopBox').hide().removeClass('prevPopBox')
		return 


# 参数列表
defaultConfig = 
	# 弹出层的z-index
	zIndex: 999
	# 是否居中显示，否为当前元素位置
	middile: true
	# 是否开启锁屏
	isLock: true
	# 是否可以点击关闭
	lockColse: false
	# 设置锁屏背景
	lockBgColor: '#000'
	# 锁屏背景透明度
	opacity: 0.5
	# 定时关闭时间
	time: null
	# 是否出现关闭按钮
	isColseBtn: true
	# 点击关闭按钮回调
	colseCallback: ->
	# 显示前回调
	beforeCallback: ->

# api
$.fn.QPop = (opts) ->
	opts = $.extend {}, defaultConfig, opts
	@each ->
		new Pop $(@), opts
