# Accord

A validation library for Crystal Objects which takes its inspiration from [Valcro](https://github.com/hgmnz/valcro), a simple validation library for Ruby. There are some differences between the Crystal version and Ruby that you'll need to pay attention to.

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  accord:
    github: neovintage/accord
```


## Usage

Validations can be defined within the object that needs to be validated or as separate classes. When using the inline method of validation,
an instance method of `validate` needs to be defined. This allows crystal to access all of the instance variables that exist as part of the
instantiated object.


```crystal
require "accord"

class Dog
  include Accord

  property name

  def validate
    errors.add(:name, "must be tough") if name != "spike"
  end
end

dog = Dog.new
dog.name = "chuck"
dog.validate!
dog.valid?  # false
dog.error_messages # ["name must be tough"]
dog.name = "spike"
dog.validate!
dog.valid?  # true
```

### Sharing Validations

One of the big values for this library is the ability to share validations across objects. When creating a validation as an object,
the validator object must:

*  Accept the object to be validated as a parameter to the constructor
*  Define a `call` instance method that accepts a parameter of type `Accord::ErrorList`
*  Be a subclass of `Accord::Validator`

```crystal
require "accord"

class NameValidator < Accord::Validator
  def initialize(context)
    @context = context
  end

  def call(errors : Accord::ErrorList)
    if @context.name != "spike"
      errors.add(:name, "must be spike")
    end
  end
end

class Dog
  include Accord
  validates_with [ NameValidator ]
end

class Cat
  include Accord
  validates_with [ NameValidator ]
end
```

In cases where you need to be more explicit when sharing validator objects, specifying a union type to the constructor may be necessary.
Here's a partial example:

```crystal
alias AnimalValidationTypes = (Dog | Cat)

class NameValidator < Accord::Validator
  def initialize(context : AnimalValidationTypes)
  end
end
```

### Mixing Validations

Accord can mix inline and sharable validations. In terms of the order of operations, sharable validations occur first and then inline
validations. The sharable validations are executed in the order that they're defined within the Array passed to `validates_with`.

```crystal
class Dog
  include Accord

  validates_with [ NameValidator, AgeValidator ]

  def validate
    errors.add(:base, "Shouldn't be barking") if night == true && barking == true
  end
end
```

In this example, `NameValidator` would be executed first, then `AgeValidator` and finally the `validate` method.

### Adding Errors

The `ErrorList` instance acts allows you to add new errors directly with the `add` instance method. When specifying the
the name of the object it must be a symbol and when that error is turned into a string, the message is appended to the
name of the symbol.

If you don't want the error message to prepend the symbol, a special symbol identifier exists called `:base`.

```crystal
errors = Accord::ErrorList.new
errors.add(:base, "I like writing my own error msgs")
errors.add(:name, "must be awesome")
errors.full_messages # ["I like writing my own error msgs", "name must be awesome"]
```

## Contributing

1. Fork it ( https://github.com/neovintage/accord/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [neovintage](https://github.com/neovintage) Rimas Silkaitis - creator, maintainer
