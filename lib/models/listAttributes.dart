class all_listAttributes {


  String title="";

  String price="";

  String type="";

  String wegiht="";

  String color="";

  String image="";

  String merchant="";

  int quantity=1;

  String size="";

  String url="";

  String dimensions = "";





  all_listAttributes (this.title, this.price, this.type,this.quantity, this.wegiht, this.color, this.image,
      this.merchant,this.size, this.url,{this.dimensions});


  String getTitle(String title)
  {
    title=this.title;
  }

  void setUrl(String url){

    this.url = url;

  }

  String getUrl(){

    return url;

  }

  Map<String, dynamic> toJsonAttr() => {
    "name": title,
    "quantity": quantity,
    "image": image,
    "price": price,
    "url":url,
    "color":color,
    "weight":wegiht,
    "merchant":merchant,
    "size":size,
    "dimensions":dimensions
  };
  Map<String, dynamic> toJsonAtt() => {
    "name": title,
    "quantity": quantity,
    "price": price,
  };

}

