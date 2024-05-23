-- put in Server Scripts

local HttpService = game:GetService("HttpService")
local textLabel = game.Workspace["Admin Playz Part"].SurfaceGui.Subs  -- Adjust this path as needed
local videoTitleLabel = game.Workspace["Admin Playz Part"].SurfaceGui.VideoTitle  -- Adjust this path as needed

local apiKey = 'NOT SHOWING'  -- Your API key
local channelId = 'UCgs2nRzDREhSzRzgUH8QyCw'  -- Your channel ID
local subsUrl = "https://www.googleapis.com/youtube/v3/channels?part=statistics&id=" .. channelId .. "&key=" .. apiKey
local videoUrl = "https://www.googleapis.com/youtube/v3/search?key=" .. apiKey .. "&channelId=" .. channelId .. "&part=snippet&order=date&maxResults=1&type=video"

local function formatSubscribers(number)
	if number >= 1000000 then
		return string.format("%.1fM", number / 1000000)  -- For millions
	elseif number >= 1000 then
		return string.format("%.2fK", number / 1000)  -- For thousands
	else
		return tostring(number)  -- For less than 1000
	end
end

local function fetchSubscriberCount()
	local success, response = pcall(function()
		return HttpService:GetAsync(subsUrl)
	end)

	if success then
		local data = HttpService:JSONDecode(response)
		if data.items and #data.items > 0 then
			local subscriberCount = tonumber(data.items[1].statistics.subscriberCount)
			return subscriberCount
		else
			return "Failed to load"
		end
	else
		warn("Failed to fetch data: " .. response)
		return nil  -- Return nil to indicate a failed fetch
	end
end

local function fetchLatestVideoTitle()
	local success, response = pcall(function()
		return HttpService:GetAsync(videoUrl)
	end)

	if success then
		local data = HttpService:JSONDecode(response)
		if data.items and #data.items > 0 then
			local videoTitle = data.items[1].snippet.title
			return videoTitle
		else
			return "No videos found"
		end
	else
		warn("Failed to fetch video data: " .. response)
		return "Failed to load"
	end
end

local function updateInfo()
	local subscriberCount = fetchSubscriberCount()
	local videoTitle = fetchLatestVideoTitle()
	if subscriberCount and videoTitle then
		textLabel.Text = "Subscribers: " .. formatSubscribers(subscriberCount)
		videoTitleLabel.Text = "Latest Video: " .. videoTitle
	else
		textLabel.Text = "Updating..."
		videoTitleLabel.Text = "Updating..."
	end
end

local function startUpdating()
	updateInfo()  -- Initial update
	while wait(15) do  -- Wait 15 seconds before each update
		print("Updating Admin Playz")
		updateInfo()
	end
end

startUpdating()  -- Call directly to start the updating process