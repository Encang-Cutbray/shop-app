import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/Product.dart';
import '../providers/products_provider.dart';

class AddProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  String _titleAppBar = 'Add Product';
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _isLoading = false;

  var _editProduct = Product(
    id: null,
    price: 0,
    title: '',
    description: '',
    imageUrl: '',
  );

  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;

      if (productId != null) {
        _titleAppBar = 'Edit Product';
        _editProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _initValues = {
          'title': _editProduct.title,
          'price': _editProduct.price.toStringAsFixed(0),
          'description': _editProduct.description,
          'imageUrl': '',
        };
        _imageUrlController.text = _editProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _setLoading(bool param) {
    setState(() {
      _isLoading = param;
    });
  }

  void _saveForm() {
    if (_form.currentState.validate()) {
      _setLoading(true);
      _form.currentState.save();

      if (_editProduct.id != null) {
        Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(_editProduct.id, _editProduct);
        _setLoading(false);
        setState(() {
          _isLoading = false;
        });
      } else {
        Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editProduct).catchError((onError) =>)
            .then((result) {
          print(result);
          _setLoading(false);
          Navigator.of(context).pop();
        }).catchError(() {});
      }
    }
  }

  Widget fieldInputTitle() {
    return TextFormField(
      initialValue: _initValues['title'],
      decoration: InputDecoration(labelText: 'Title'),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) =>
          FocusScope.of(context).requestFocus(_priceFocusNode),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please fill the title';
        }
        return null;
      },
      onSaved: (value) => _editProduct = Product(
        id: _editProduct.id,
        isFavorite: _editProduct.isFavorite,
        title: value,
        price: _editProduct.price,
        description: _editProduct.description,
        imageUrl: _editProduct.imageUrl,
      ),
    );
  }

  Widget fieldInputPrice() {
    return TextFormField(
      initialValue: _initValues['price'],
      decoration: InputDecoration(labelText: 'Price'),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      focusNode: _priceFocusNode,
      onFieldSubmitted: (_) =>
          FocusScope.of(context).requestFocus(_descriptionFocusNode),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter a price.';
        }
        if (double.tryParse(value) == null) {
          return 'Please enter valid number.';
        }
        if (double.parse(value) <= 0) {
          return 'Plese enter a number greater than zero.';
        }
        return null;
      },
      onSaved: (value) => _editProduct = Product(
        id: _editProduct.id,
        isFavorite: _editProduct.isFavorite,
        title: _editProduct.title,
        price: double.parse(value),
        description: _editProduct.description,
        imageUrl: _editProduct.imageUrl,
      ),
    );
  }

  Widget fieldInputDescription() {
    return TextFormField(
      initialValue: _initValues['description'],
      decoration: InputDecoration(labelText: 'Description'),
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      focusNode: _descriptionFocusNode,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter a description';
        }

        if (value.length < 10) {
          return 'The description should be at last 10 character long';
        }
        return null;
      },
      onFieldSubmitted: (_) =>
          FocusScope.of(context).requestFocus(_descriptionFocusNode),
      onSaved: (value) => _editProduct = Product(
        id: _editProduct.id,
        isFavorite: _editProduct.isFavorite,
        title: _editProduct.title,
        price: _editProduct.price,
        description: value,
        imageUrl: _editProduct.imageUrl,
      ),
    );
  }

  Widget fieldInputImage() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          width: 100,
          height: 100,
          margin: EdgeInsets.only(top: 8, right: 8),
          decoration: BoxDecoration(
            border: Border.all(width: 1),
            color: Colors.white70,
          ),
          child: _imageUrlController.text.isEmpty
              ? Text('Enter a Url')
              : FittedBox(
                  child: Image.network(_imageUrlController.text),
                ),
        ),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Image Url'),
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
            controller: _imageUrlController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter an image Url';
              }

              if (!value.startsWith('http') && !value.startsWith('https')) {
                return 'Please enter valid Url';
              }
              return null;
            },
            onFieldSubmitted: (_) => _saveForm(),
            onSaved: (value) => _editProduct = Product(
              id: _editProduct.id,
              isFavorite: _editProduct.isFavorite,
              title: _editProduct.title,
              price: _editProduct.price,
              description: _editProduct.description,
              imageUrl: value,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleAppBar),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _form,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: ListView(
                  children: <Widget>[
                    fieldInputTitle(),
                    fieldInputPrice(),
                    fieldInputDescription(),
                    fieldInputImage(),
                  ],
                ),
              ),
            ),
    );
  }
}
