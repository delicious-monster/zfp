.. _references:

References
----------

Should operator() return const reference?  Could that be unsafe if the
return value is part of an expression, where one part of the expression
kicks out the referenced other part from the cache?  Are const referenced
objects immutable?  I don't see why.

