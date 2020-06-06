import gleam/list
import gleam/int as int_mod
import gleam/float as float_mod
import gleam/option.{Option, None, Some}
import gleam/iodata.{Iodata}

pub external type Builder

external fn erase(a) -> Builder =
  "gleam@dynamic" "unsafe_coerce"

pub external fn to_iodata(Builder) -> Iodata =
  "gleam@dynamic" "unsafe_coerce"

pub fn to_string(builder: Builder) -> String {
  builder
  |> to_iodata
  |> iodata.to_string
}

pub fn int(i: Int) -> Builder {
  i
  |> int_mod.to_string
  |> erase
}

pub fn float(f: Float) -> Builder {
  f
  |> float_mod.to_string
  |> erase
}

pub fn array(f: List(Builder)) -> Builder {
  f
  |> list.intersperse(erase(","))
  |> erase
  |> to_iodata
  |> iodata.append("]")
  |> iodata.prepend("[")
  |> erase
}

pub fn true() -> Builder {
  erase("true")
}

pub fn false() -> Builder {
  erase("false")
}

pub fn null() -> Builder {
  erase("null")
}

// TODO: test
pub fn nullable(n: Option(Builder)) -> Builder {
  case n {
    Some(x) -> x
    None -> null()
  }
}

// TODO: escape
pub fn string(s: String) -> Builder {
  s
  |> iodata.new
  |> iodata.append("\"")
  |> iodata.prepend("\"")
  |> erase
}

pub fn object(fields: List(tuple(String, Builder))) -> Builder {
  fields
  |> list.map(
    fn(tup) {
      let tuple(key, value) = tup
      key
      |> string
      |> to_iodata
      |> iodata.append(":")
      |> iodata.append_iodata(to_iodata(value))
    },
  )
  // TODO: use fold rather than map + intersperse
  |> list.intersperse(iodata.new(","))
  |> iodata.concat
  |> iodata.prepend("{")
  |> iodata.append("}")
  |> erase
}
