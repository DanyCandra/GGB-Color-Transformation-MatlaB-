function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 17-Feb-2020 09:26:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI

handles.output = hObject;
set(handles.btn_ggb,'Enable','off');
set(handles.btn_save,'Enable','off');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_choose.
function btn_choose_Callback(hObject, eventdata, handles)
% hObject    handle to btn_choose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%membaca input image
global imageInput
[path, user_cancel]=imgetfile();
if user_cancel
   msgbox(sprintf('Invalid Selection'),'Error', 'Warn');
   return
end
imageInput=imread(path);
imageInput=im2double(imageInput);
axes(handles.axes1);
imshow(imageInput)

 set(handles.btn_ggb,'Enable','on');
 set(handles.btn_save,'Enable','off');

guidata(hObject, handles);


% --- Executes on button press in btn_ggb.
function btn_ggb_Callback(hObject, eventdata, handles)
% hObject    handle to btn_ggb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%membaca input image
global imageInput

%memisah komponen R G B
red = imageInput(:,:,1); % Red channel
green = imageInput(:,:,2); % Green channel
blue = imageInput(:,:,3); % Blue channel

%Normalisasi Komponen G 
greenMean1=mean(green);
greenMean2=mean(greenMean1);
greenNormal=double(green)/greenMean2;
greenImg=imadjust(greenNormal);

%Normalisasi Komponen B 
blueMean1=mean(blue);
blueMean2=mean(blueMean1);
blueNormal=double(blue)/blueMean2;

%Mengabungkan Komponen GGB 
ggb = cat(3, greenImg, greenImg, blueNormal);
axes(handles.axes2);
imshow(ggb)

set(handles.btn_save,'Enable','on');
guidata(hObject, handles);


% --- Executes on button press in btn_save.
function btn_save_Callback(hObject, eventdata, handles)
% hObject    handle to btn_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global frame
[name_file_save,path_save] = uiputfile( ...
    {'*.bmp','File Bitmap (*.bmp)';...
    '*.jpg','File jpeg (*.jpg)';
    '*.tif','File Tif (*.tif)';
    '*.*','All Files (*.*)'},...
    'Save Image');
if ~isequal(name_file_save,0)
    f=getframe(handles.axes2);
    imageOutput=frame2im(f);
    imwrite(imageOutput,fullfile(path_save,name_file_save));
    msgbox('Image is Saved','Foto Editor')
else
   return
end

axes(handles.axes1);
hold off;
cla reset;
set(gca,'XTick',[])
set(gca,'YTick',[])

axes(handles.axes2);
hold off;
cla reset;
set(gca,'XTick',[])
set(gca,'YTick',[])


set(handles.btn_ggb,'Enable','off');
set(handles.btn_save,'Enable','off');
guidata(hObject, handles);