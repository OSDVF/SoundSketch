.pragma library

function reposition(list, index) {
    if(list.count === 1)
        return true;

    var thisItem = list.get(index);
    var newPos = thisItem.posMs;

    var newIndex = 0;
    for(newIndex = 0; newIndex < list.count; newIndex++)
    {
        if(list.get(newIndex).posMs > newPos)
        {
            break;
        }
    }
    newIndex--;
    if(newIndex < 0) newIndex = 0;
    if(newIndex !== index)
    {
        list.move(index, newIndex, 1);
    }
    thisItem = list.get(newIndex);
    var leftIndex = newIndex - 1;
    var rightIndex = newIndex + 1;
    var itemsCount = list.count;
    var overlapingItem;

    if(leftIndex >= 0)
    {
        var leftItem = list.get(leftIndex);
        //Do or discard the position change
        overlapingItem = leftItem;
        var overlapingDuration = overlapingItem.audioFile.durationMs;
        var overlapingEnd = overlapingItem.posMs + overlapingItem.audioFile.durationMs;
        if(newPos < overlapingEnd)//left edge is within boundf of another item
        {
            var leftItemShiftPos = newPos - overlapingDuration;
            if(leftIndex > 0)
            {
                var lefterItem = list.get(leftIndex - 1);
                if(lefterItem.posMs + lefterItem.audioFile.durationMs <= leftItemShiftPos )
                {
                    console.log("Set left item pos to " << leftItemShiftPos);
                    leftItem.posMs = leftItemShiftPos;
                    return true;
                }
                else return false;
            }
            else if(leftItemShiftPos >= 0)
            {
                console.log("Set first item pos to " ,leftItemShiftPos);
                leftItem.posMs = (leftItemShiftPos);
                return true;
            }
            return false;
        }
    }
    if(rightIndex < itemsCount)
    {
        var rightItem = list.get(rightIndex);
        //Do or discard the position change
        overlapingItem = rightItem;
        var overlapPos = overlapingItem.posMs;
        var newEnd = thisItem.posMs + thisItem.audioFile.durationMs

        if(newEnd > overlapPos)//right edge is within boundf of another item
        {
            var rightItemShiftPos = newPos + thisItem.audioFile.durationMs;
            if(rightIndex < itemsCount - 1)
            {
                var evenRighterItem = list.get(rightIndex + 1);
                if(evenRighterItem.posMs >= rightItemShiftPos + evenRighterItem.audioFile.durationMs )
                {
                    console.log( "Set right item pos to ", rightItemShiftPos);
                    rightItem.posMs = (rightItemShiftPos);
                    return true;
                }
                return false;
            }
            else if(rightItemShiftPos >= 0)
            {
                console.log("Set last item pos to ", rightItemShiftPos);
                rightItem.posMs = (rightItemShiftPos);
                return true;
            }
            return false;
        }
    }
    return true;
}
