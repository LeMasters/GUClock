-- Digital clock, with reformatted UI for different orientations
-- With additions, emandations by G.LeMasters
-- Version: 2.0a
-- 
-- Original code is MIT licensed, see http://www.coronalabs.com/links/code/license

display.setStatusBar( display.HiddenStatusBar )
local clock = display.newGroup()
local background = display.newImage( "GUKey.jpg", 160, 240 )
clock:insert( background )

-- Create dynamic textfields
-- Note: these are iOS/MacOS fonts. If building for Android, choose available system fonts, 
-- or use native.systemFont / native.systemFontBold

local hourField = display.newText( clock, "", 100, 90, native.systemFontBold, 180 )
hourField:setFillColor( 105/255, 105/255, 105/255, 170/255 )
hourField.rotation = -15

local minuteField = display.newText( clock, "", 100, 240, native.systemFontBold, 180 )
minuteField:setFillColor( 105/255, 105/255, 105/255, 170/255 )
minuteField.rotation = -15

local secondField = display.newText( clock, "", 100, 390, native.systemFontBold, 180 )
secondField:setFillColor( 105/255, 105/255, 105/255, 170/255 )
secondField.rotation = -15

-- Create captions
local hourLabel = display.newText( clock, "hours ", 220, 100, native.systemFont, 40 )
hourLabel:setFillColor( 70/255, 130/255, 180/255 )

local minuteLabel = display.newText( clock, "minutes ", 220, 250, native.systemFont, 40 )
minuteLabel:setFillColor( 70/255, 130/255, 180/255 )

local secondLabel = display.newText( clock, "seconds ", 210, 400, native.systemFont, 40 )
secondLabel:setFillColor( 70/255, 130/255, 180/255 )

-- Set the rotation point to the center of the screen
clock.anchorChildren = true 
clock.x, clock.y = display.contentCenterX, display.contentCenterY
 
local function updateTime()
	local time = os.date("*t")
	
	local hourText = time.hour
	if (hourText < 10) then hourText = "0" .. hourText end
	hourField.text = hourText
	
	local minuteText = time.min
	if (minuteText < 10) then minuteText = "0" .. minuteText end
	minuteField.text = minuteText
	
	local secondText = time.sec
	if (secondText < 10) then secondText = "0" .. secondText end
	secondField.text = secondText
end

updateTime() -- run once on startup, so correct time displays immediately

-- Update the clock once per second
local clockTimer = timer.performWithDelay( 1000, updateTime, -1 )

-- Use accelerometer to rotate display automatically
local function onOrientationChange( event )

print( clock.anchorX, clock.anchorY, clock.x, clock.y )
	-- Adapt text layout to current orientation	
	local direction = event.type

	if ( direction == "landscapeLeft" or direction == "landscapeRight" ) then
		hourField.y = 120
		secondField.y = 360
		hourLabel.y = 130
		secondLabel.y = 370
	elseif ( direction == "portrait" or direction == "portraitUpsideDown" ) then
		hourField.y = 90
		secondField.y = 390
		hourLabel.y = 100
		secondLabel.y = 400
	end

	-- Rotate clock so it remains upright
	local newAngle = clock.rotation - event.delta
	transition.to( clock, { time=1500, rotation=newAngle } )	

end

Runtime:addEventListener( "orientation", onOrientationChange )