Base.:(==)(x::FloatD64, y::FloatD64) =
    Hi(x) === Hi(y) && Lo(x) === Lo(y)

Base.:(!=)(x::FloatD64, y::FloatD64) =
    Lo(x) !== Lo(y) || Hi(x) !== Hi(y)

Base.:(<)(x::FloatD64, y::FloatD64) =
    Hi(x) < Hi(y) || (Hi(x) === Hi(y) && Lo(x) < Lo(y))

Base.:(>)(x::FloatD64, y::FloatD64) =
    Hi(x) > Hi(y) || (Hi(x) === Hi(y) && Lo(x) > Lo(y))

Base.:(<=)(x::FloatD64, y::FloatD64) =
    Hi(x) < Hi(y) || (Hi(x) === Hi(y) && Lo(x) <= Lo(y))

Base.:(>=)(x::FloatD64, y::FloatD64) =
    Hi(x) > Hi(y) || (Hi(x) === Hi(y) && Lo(x) >= Lo(y))

Base.isequal(x::FloatD64, y::FloatD64) =
    Hi(x) === Hi(y) && Lo(x) === Lo(y)

Base.isless(x::FloatD64, y::FloatD64) =
    Hi(x) < Hi(y) || (Hi(x) === Hi(y) && Lo(x) < Lo(y))
