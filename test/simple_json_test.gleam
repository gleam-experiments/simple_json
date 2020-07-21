import simple_json.{
  array, false, float, int, null, nullable, object, string, true
}
import gleam/option.{None, Some}
import gleam/should

pub fn encoding_test() {
  object(
    [
      tuple("name", string("Sid")),
      tuple("level", int(50)),
      tuple("weakness", null()),
      tuple(
        "flags",
        array([true(), false(), null(), nullable(None), nullable(Some(int(1)))]),
      ),
    ],
  )
  |> simple_json.to_string
  |> should.equal(
    "{\"name\":\"Sid\",\"level\":50,\"weakness\":null,\"flags\":[true,false,null,null,1]}",
  )
}
