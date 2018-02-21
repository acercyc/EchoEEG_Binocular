function checkScreenSetting(windowNum)

windowInfo = Screen('Resolution', windowNum);
if windowInfo.width ~= 800 || windowInfo.height ~= 600 || windowInfo.hz ~= 160
    error('resolution setting is wrong');
end