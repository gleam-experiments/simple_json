import simple_json.{object, int, float, string, array, null, nullable, true, false}
import gleam/option.{Some, None}
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
