# `Person`: This is my Person class

## Description

Person class description

## Public fields

* `name`: Name of the person
* `hair`: Hair colour

## Methods

### Public methods

* [`Person$new()`](#method-Person-new)
* [`Person$set_hair()`](#method-Person-set_hair)
* [`Person$clone()`](#method-Person-clone)

### Method `new()`

Create a person

#### Usage

```
Person$new(name = NA, hair = NA)
```

#### Arguments

* `name`: Name of the person
* `hair`: Hair colour

### Method `set_hair()`

Set hair

#### Usage

```
Person$set_hair(val)
```

#### Arguments

* `val`: Hair colour

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

```
Person$clone(deep = FALSE)
```

#### Arguments

* `deep`: Whether to make a deep clone.

## Examples

```r
Person$new(name="Bill", hair="Blond")
```

