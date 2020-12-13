function appendClip(posMs, audioFileName)
{
    var file = fileFactory.create(audioFileName)
    var duration = file.durationMs;

    var correctIndex = getIndexForNewItem(posMs, duration);
    var correctPos = getCorrectPosForNewItem(posMs, duration, correctIndex);
    if(file.durationMs === 0)
        console.warn("Adding clip with zero duration.");

    //correctIndex = getIndexForNewItem(correctPos, duration);//Correct the index according to the new position

    clipList.insert(correctIndex, {
                        posMs: correctPos,
                        audioFile: file
                    });
}

function getCorrectPosForNewItem(posMs, duration, requestedIndex)
{
    var lastFreePos = posMs;
    if(requestedIndex >= clipList.count)//If inserting the last item
    {
        if(clipList.count > 0)
        {
            var it = clipList.get(clipList.count -1);
            var end = it.posMs - it.audioFile.startMs + it.audioFile.endMs;
            if(posMs < end)
            {
                return end;
            }
        }
        return lastFreePos;
    }

    for(var i = requestedIndex; i< clipList.count; i++)
    {
        var currentItem = clipList.get(i);
        var newItemEnd = lastFreePos + duration;
        var currentEnd = currentItem.posMs - currentItem.audioFile.startMs + currentItem.audioFile.endMs;
        if(lastFreePos < currentItem.posMs && newItemEnd < currentEnd)//Find the item before which it will be placed
        {
            if (i - 1 >= 0)//If we are positioning not the first item
            {
                var prevItem = clipList.get(i - 1);
                var prevEnd = prevEnd.posMs - prevEnd.audioFile.startMs + prevEnd.audioFile.endMs;
                if (prevEnd >= lastFreePos)//Sync with previous item
                {
                    lastFreePos = prevEnd;
                    continue;
                }
            }
            else if(i < clipList.count)//Sync with next item (it will be i+1, but now it is at index 'i')
            {
                var nextItem = clipList.get(i);
                if (nextItem.posMs < newItemEnd && nextItem.posMs > lastFreePos)
                {
                    lastFreePos = nextItem.posMs - nextItem.audioFile.startMs + nextItem.audioFile.endMs;
                    continue;
                }
            }
            return lastFreePos;
        }
        else
        {
            lastFreePos = currentEnd;
        }
    }
    //This should not be reached
    console.warn("Couldn't find pos for item at pos ", posMs, " duration ", duration, " reqIndex ", requestedIndex);
    return lastFreePos;
}

function getIndexForNewItem(posMs, duration)
{
    for(var i =0; i<clipList.count; i++)
    {
        if(clipList.get(i).posMs > posMs)
        {
            if(i - 1 >= 0 )//If we are iterating not the first item
            {
                var prevItem = clipList.get(i - 1);
                if(prevItem.posMs + prevItem.audioFile.endMs - prevItem.audioFile.startMs + duration >= clipList.get(i).posMs)//If newly added item at this position would overlap the next item
                {
                    continue;
                }
            }
            else if (i < clipList.count)//Sync with next item (it will be i+1, but now it is at index 'i')
            {
                var nextItem = clipList.get(i);
                if (nextItem.posMs < posMs + duration && nextItem.posMs > posMs)
                {
                    continue;
                }
            }
            return i;
        }
    }
    //This should be reached when item recieves the last position
    return clipList.count;
}

function getIndexOfItemAtPos(posMs)
{
    for(var i =0; i<clipList.count; i++)
    {
        var item = clipList.get(i)
        var endMs = item.posMs + item.audioFile.endMs - item.audioFile.startMs;
        if(posMs >= item.posMs && posMs <= endMs)
        {
            return i;
        }
    }
    return -1;
}
