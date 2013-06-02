require './network_layer'

n = NetworkLayer.new

n.upload("poop.txt")
n.upload("working-draft.txt")
n.upload("string test")
n.upload("Screen Shot 2013-05-24 at 11.11.40 PM (2).png")
n.list_contents
n.link("Screen Shot 2013-05-24 at 11.11.40 PM (2).png")
n.download("poop.txt")
n.download("magnum-opus.txt")
n.download("working-draft.txt")
n.download("Screen Shot 2013-05-24 at 11.11.40 PM (2).png")
n.search("poop.txt")
n.search("magnum")
