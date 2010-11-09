module Crusher::Util
  DUMMY_WORDS = %w( Vivamus condimentum mi vel massa blandit ut pretium risus cursus Pellentesque eu mollis turpis Cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus Phasellus lobortis bibendum lectus Suspendisse suscipit sem in arcu tempor at malesuada lectus facilisis Sed euismod pretium gravida Ut feugiat tortor a erat mattis a eleifend est rutrum Ut est elit accumsan ut lacinia ac dignissim tincidunt elit Duis nisi mauris ornare eget laoreet vel euismod at sem Donec in neque nec odio ornare vestibulum Pellentesque ut turpis erat nec sollicitudin nulla Nulla varius fringilla porta Fusce sit amet orci eget sem iaculis porttitor Proin pulvinar sodales odio in dapibus erat viverra in Donec fringilla lacus et lacus tincidunt ut laoreet dolor tristique Nullam vulputate iaculis condimentum Mauris et ligula id erat auctor adipiscing Nulla luctus interdum consequatProin vehicula egestas leo a feugiat velit fermentum quis Morbi mattis dignissim tincidunt Nunc sed dignissim leo Mauris vitae mi sollicitudin eros elementum interdum non quis velit Nam eleifend aliquam lobortis Maecenas in metus non libero porttitor tincidunt vitae molestie augue Lorem ipsum dolor sit amet consectetur adipiscing elit Vestibulum blandit erat ac urna gravida ac aliquam nulla scelerisque Fusce ante purus rhoncus auctor molestie vel tincidunt sit amet orci Sed viverra augue ut quam condimentum dictum Duis ullamcorper elit in erat ullamcorper eget rhoncus velit blandit Morbi ultrices lacus id suscipit tempor turpis dolor placerat ante tempor mollis turpis leo et augue Phasellus augue dolor ultrices luctus rhoncus nec sollicitudin sit amet nequeVestibulum interdum nibh sed mauris vulputate sed tincidunt magna rhoncus Etiam sapien metus ultricies in eleifend a aliquet eget nibh Duis in est nibh eu tincidunt enim Vivamus suscipit felis a velit dignissim et fringilla mi laoreet Duis metus odio porta vitae dictum in rutrum ut quam Donec tristique adipiscing nisl non iaculis Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas Nulla eget pulvinar nulla Cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus Donec venenatis justo eu vulputate venenatis leo ante varius enim ac laoreet lacus elit id ipsum Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas Etiam euismod lorem quis faucibus vehicula nisi lorem mattis felis in imperdiet urna magna non dolor Aenean sed eros eu odio pretium blandit In hac habitasse platea dictumst Vestibulum nisi orci malesuada eu adipiscing eget posuere nec orci Curabitur bibendum orci non felis faucibus lobortisSuspendisse imperdiet pellentesque magna sit amet commodo odio hendrerit vitae Duis dapibus tempor nunc interdum vulputate Curabitur fringilla erat ut magna viverra pulvinar sed eu nunc Phasellus sit amet aliquam nulla Donec aliquam nibh in ullamcorper dictum nibh risus pellentesque nunc eu laoreet nulla elit sed justo Donec blandit justo eu mi ultricies eu tempus turpis fringilla Proin ligula elit varius vel egestas et hendrerit sed metus Phasellus nec tortor nunc eu auctor quam Nulla quis ultricies felis Proin iaculis felis non ultrices ) 

  def self.nrand(min, max)
    (1..6).map{ rand(min,max) }.sum / 6
  end

  # http://en.wikipedia.org/wiki/Poisson_distribution
  def self.prand(lamb, min, max)
    l, k, p = [(2.718 ** (-lamb)), 1, rand]
    k += 1 and p *= rand while p > l
    ((k * (max - min)) + min).to_i
  end

  def self.lipsum(words)
    (1..words).map{ DUMMY_WORDS[ rand(DUMMY_WORDS.length) ] }.join(' ')
  end
  
end