Base.:(==)(x::Double64, y::Double64) =
    Hi(x) === Hi(y) && Lo(x) === Lo(y)

Base.:(!=)(x::Double64, y::Double64) =
    Lo(x) !== Lo(y) || Hi(x) !== Hi(y)

Base.:(<)(x::Double64, y::Double64) =
    Hi(x) < Hi(y) || (Hi(x) === Hi(y) && Lo(x) < Lo(y))

Base.:(>)(x::Double64, y::Double64) =
    Hi(x) > Hi(y) || (Hi(x) === Hi(y) && Lo(x) > Lo(y))

Base.:(<=)(x::Double64, y::Double64) =
    Hi(x) < Hi(y) || (Hi(x) === Hi(y) && Lo(x) <= Lo(y))

Base.:(>=)(x::Double64, y::Double64) =
    Hi(x) > Hi(y) || (Hi(x) === Hi(y) && Lo(x) >= Lo(y))

Base.isequal(x::Double64, y::Double64) =
    Hi(x) === Hi(y) && Lo(x) === Lo(y)

Base.isless(x::Double64, y::Double64) =
    Hi(x) < Hi(y) || (Hi(x) === Hi(y) && Lo(x) < Lo(y))
