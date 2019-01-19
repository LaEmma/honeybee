# -*- coding: utf-8 -*-
import numpy as np
import scipy.stats 
import re
import pprint
from file_import import ExcelImporter
from constants import DataImportFields1314, DataImportFields1415, \
    DataImportFields1516, DataImportFields1617, Province, ApiarySize,\
    BeeType
from utils import is_valid_data

import matplotlib
import matplotlib.pyplot as plt

'''
结果说明

total 
    province
        anhui
            mfi
            num
13-14
    province
14-15
    province
        
15-16
    province

'''


class DataController(object):
    """docstring for DataController"""
    def __init__(self):
        super(DataController, self).__init__()
        self.confidence = 0.95
        self.loss_rate = {}
        self.western_loss_rate = {}
        self.eastern_loss_rate = {}
        self.province_list = set()
        self.comb_list = set()
        self.qchange_num_list = set()
        self.nectar_list = set()
        # self.base_path = "F:/Emma/data/"
        self.base_path = "/Users/liuchao/work3/honey_bee/181029/data/"


    def analysis(self):

        # 1314年数据读入
        # 数据清洗，过滤掉无效数据
        # import pdb; pdb.set_trace()
        # filepath = '/Users/liuchao/work3/honey_bee/181029/data/DataExport_13-14_LZG.xlsx'
        filepath = self.base_path + 'DataExport_13-14_LZG.xlsx'
        raw_data_1314 = self.get_raw_excel_data(DataImportFields1314.fields, filepath)
        data_1314 = self.clean_raw_data_1(raw_data_1314)
        western_data_1314 = [item for item in data_1314 if item['Race'] == BeeType.WESTERN]
        eastern_data_1314 = [item for item in data_1314 if item['Race'] == BeeType.EASTERN]
        
        # 1415年数据读入
        # 数据清洗，过滤掉无效数据
        filepath = self.base_path + 'DataExport-COLOSS14-15.xlsx'
        raw_data_1415 = self.get_raw_excel_data(DataImportFields1415.fields, filepath)
        data_1415 = self.clean_raw_data_1(raw_data_1415)
        western_data_1415 = [item for item in data_1415 if item['Race'] == BeeType.WESTERN]
        eastern_data_1415 = [item for item in data_1415 if item['Race'] == BeeType.EASTERN]

        # 1516年数据读入
        # 数据清洗，过滤掉无效数据
        # import pdb; pdb.set_trace()
        filepath = self.base_path + 'Data-coloss15-16.xlsx'
        raw_data_1516 = self.get_raw_excel_data(DataImportFields1516.fields, filepath)
        data_1516 = self.clean_raw_data_2(raw_data_1516)
        western_data_1516 = [item for item in data_1516 if item['Race'] == BeeType.WESTERN]
        eastern_data_1516 = [item for item in data_1516 if item['Race'] == BeeType.EASTERN]

        # 1617年数据读入
        # 数据清洗，过滤掉无效数据
        filepath = self.base_path + 'Data-coloss 16-17.xlsx'
        raw_data_1617 = self.get_raw_excel_data(DataImportFields1617.fields, filepath)
        data_1617 = self.clean_raw_data_2(raw_data_1617)
        western_data_1617 = [item for item in data_1617 if item['Race'] == BeeType.WESTERN]
        eastern_data_1617 = [item for item in data_1617 if item['Race'] == BeeType.EASTERN]

        self.province_list = sorted(self.province_list)
        self.comb_list = sorted(self.comb_list)
        # 按中蜂和西蜂两大组数据分析损失率
        ################ 西蜂 #######################
        print("西蜂")
        self.western_loss_rate = self.calculation(western_data_1314, western_data_1415,\
            western_data_1516, western_data_1617)
        # print("西蜂： %s" % self.western_loss_rate)
        self.plot_apiary(loss_rate['apiary'])
        
        ################ 中蜂 #######################
        # print("中蜂")
        # self.eastern_loss_rate = self.calculation(eastern_data_1314, eastern_data_1415,\
        #     eastern_data_1516, eastern_data_1617)
        # print("中蜂： %s" % self.eastern_loss_rate)

    def calculation(self, data_1314, data_1415, data_1516, data_1617):
        loss_rate = {}
        loss_rate1314 = {}
        loss_rate1415 = {}
        loss_rate1516 = {}
        loss_rate1617 = {}
        # 准备数据
        total_data = data_1314 + data_1415 + data_1516 + data_1617
        total_col_init_oct_1314 = [int(item.get('COL_INIT_OCT')) for item in data_1314]
        total_col_loss_1314 = [int(item.get('COL_LOSS')) for item in data_1314]
        total_col_init_oct_1415 = [int(item.get('COL_INIT_OCT')) for item in data_1415]
        total_col_loss_1415 = [int(item.get('COL_LOSS')) for item in data_1415]
        total_col_init_oct_1516 = [int(item.get('COL_INIT_OCT')) for item in data_1516]
        total_col_loss_1516 = [int(item.get('COL_LOSS')) for item in data_1516]
        total_col_init_oct_1617 = [int(item.get('COL_INIT_OCT')) for item in data_1617]
        total_col_loss_1617 = [int(item.get('COL_LOSS')) for item in data_1617]
        total_col_init_oct = total_col_init_oct_1314 + total_col_init_oct_1415 + \
                            total_col_init_oct_1516 + total_col_init_oct_1617
        total_col_loss = total_col_loss_1314 + total_col_loss_1415 + \
                            total_col_loss_1516 + total_col_loss_1617
        loss_rate = self.inner_calculation(total_data)
        # 总损失率
        total_loss_rate = self.cal_total_loss_rate(total_col_init_oct, total_col_loss)
        loss_rate['total'] = total_loss_rate
        # 按年份损失率
        loss_rate_1314 = self.cal_total_loss_rate(total_col_init_oct_1314, total_col_loss_1314)
        loss_rate['13-14'] = loss_rate_1314

        loss_rate_1415 = self.cal_total_loss_rate(total_col_init_oct_1415, total_col_loss_1415)
        loss_rate['14-15'] = loss_rate_1415

        loss_rate_1516 = self.cal_total_loss_rate(total_col_init_oct_1516, total_col_loss_1516)
        loss_rate['15-16'] = loss_rate_1516

        loss_rate_1617 = self.cal_total_loss_rate(total_col_init_oct_1617, total_col_loss_1617)
        loss_rate['16-17'] = loss_rate_1617
        
        loss_rate1314 = self.inner_calculation(data_1314)
        loss_rate1415 = self.inner_calculation(data_1415)
        loss_rate1516 = self.inner_calculation(data_1516)
        loss_rate1617 = self.inner_calculation(data_1617)
        
        '''
        {'14-15': (0.11516167557015994, 0.10275074376876998, 0.1275726073715499), 
        '16-17': (0.09276281408596232, 0.08539412757129532, 0.10013150060062932), 
        'total': (0.10097859910256822, 0.0967598904044299, 0.10519730780070655), 
        '13-14': (0.09469177253805378, 0.08764194209700885, 0.1017416029790987), 
        '15-16': (0.11110466980145861, 0.1026427608405073, 0.11956657876240992),
        'province': {'beijing': (xxx, xxx, xxx)}},
        'apiary': {'small': (xxx, xxx, xxx)}},
        'comb': {'0': (xxx, xxx, xxx)}},
        '''
        # pprint.pprint(loss_rate)
        result = {
            "total": loss_rate,
            "13-14": loss_rate1314,
            "14-15": loss_rate1415,
            "15-16": loss_rate1516,
            "16-17": loss_rate1617,
        }
        # pprint.pprint(result)
        return result

    def inner_calculation(self, input_data):
        # 按省份损失率
        loss_rate = {}
        loss_rate['province'] = {}
        province_col_init = {}
        province_col_loss = {}

        # 按蜂群大小损失率
        loss_rate['apiary'] = {}
        apiary_col_init = {}
        apiary_col_loss = {}

        # 新脾比例 Comb
        loss_rate['comb'] = {}
        comb_col_init = {}
        comb_col_loss = {}

        # 换王次数 QChange
        loss_rate['qchange'] = {}
        qchange_col_init = {}
        qchange_col_loss = {}

        for item in input_data:
            
            province = item['Province']
            col_init = int(item.get('COL_INIT_OCT'))
            col_loss = int(item.get('COL_LOSS'))

            if province not in province_col_init.keys():
                province_col_init[province] = [col_init]
                province_col_loss[province] = [col_loss]
            else:
                province_col_init[province].append(col_init)
                province_col_loss[province].append(col_loss)
        
            apiary = item['ApiarySize']
            # col_init = int(item.get('COL_INIT_OCT'))
            # col_loss = int(item.get('COL_LOSS'))

            if apiary not in apiary_col_init.keys():
                apiary_col_init[apiary] = [col_init]
                apiary_col_loss[apiary] = [col_loss]
            else:
                apiary_col_init[apiary].append(col_init)
                apiary_col_loss[apiary].append(col_loss)


            comb = item['Comb']
            # col_init = int(item.get('COL_INIT_OCT'))
            # col_loss = int(item.get('COL_LOSS'))

            if comb not in comb_col_init.keys():
                comb_col_init[comb] = [col_init]
                comb_col_loss[comb] = [col_loss]
            else:
                comb_col_init[comb].append(col_init)
                comb_col_loss[comb].append(col_loss)

            # 换王次数
            qchange = item['QChange']
            if qchange not in qchange_col_init.keys():
                qchange_col_init[qchange] = [col_init]
                qchange_col_loss[qchange] = [col_loss]
            else:
                qchange_col_init[qchange].append(col_init)
                qchange_col_loss[qchange].append(col_loss)

        # import pdb;pdb.set_trace()
        # 按省份损失率
        for province in self.province_list:
            loss_rate['province'][province] = {}
            if province not in province_col_init.keys():
                loss_rate['province'][province]["num"] = 0
                loss_rate['province'][province]["mfi"] = (0.0, 0.0, 0.0)
            else:
                province_loss_rate = self.cal_total_loss_rate(province_col_init[province], province_col_loss[province])
                loss_rate['province'][province]["num"] = len(province_col_init[province])
                loss_rate['province'][province]["mfi"] = province_loss_rate
            
        # 按蜂群大小损失率
        for apiary in [ApiarySize.SMALL, ApiarySize.MEDIUM, ApiarySize.LARGE]:
            apiary_loss_rate = self.cal_total_loss_rate(apiary_col_init[apiary], apiary_col_loss[apiary])
            num = len(apiary_col_init[apiary])
            loss_rate['apiary'][apiary] = {}
            loss_rate['apiary'][apiary]["num"] = num
            loss_rate['apiary'][apiary]["mfi"] = apiary_loss_rate
            # 画图用
            rate = []
            for count in range(num):
                start = apiary_col_init[apiary][count]
                end = apiary_col_loss[apiary][count]
                if start > 0:
                    rate.append(float(end/start))
                else:
                    rate.append(0)
            loss_rate['apiary'][apiary]["rate"] = rate
            # print("===one_loss_rate: %s" % rate)

        # 新脾比例 Comb
        # 散点图和线性回归？？？？
        for comb in self.comb_list:
            loss_rate['comb'][comb] = {}
            if comb not in comb_col_init.keys():
                loss_rate['comb'][comb]["num"] = 0
                loss_rate['comb'][comb]["mfi"] = (0.0, 0.0, 0.0)
            else:
                comb_loss_rate = self.cal_total_loss_rate(comb_col_init[comb], comb_col_loss[comb])
                loss_rate['comb'][comb]["num"] = len(comb_col_init[comb])
                loss_rate['comb'][comb]["mfi"] = comb_loss_rate
        
        # 平均每群产蜜量
        # 无

        # 采用的换王方法： 自然更换王替， 购买蜂王，自己育王


        # 新蜂王比例



        # 换王次数
        for qchange in self.qchange_num_list:
            loss_rate['qchange'][qchange] = {}
            if qchange not in qchange_col_init.keys():
                loss_rate['qchange'][qchange]["num"] = 0
                loss_rate['qchange'][qchange]["mfi"] = (0.0, 0.0, 0.0)
            else:
                qchange_loss_rate = self.cal_total_loss_rate(qchange_col_init[qchange], qchange_col_loss[qchange])
                loss_rate['qchange'][qchange]["num"] = len(qchange_col_init[qchange])
                loss_rate['qchange'][qchange]["mfi"] = qchange_loss_rate
        # print(loss_rate['qchange'])
        
        # 蜜源植物


        # 蜂种


        # 敌害


        # 越冬饲喂


        # 治螨

        return loss_rate

    def get_raw_excel_data(self, importfields, filepath):
        # 读取excel的数据
        excel_importer = ExcelImporter(importfields)
        file_data = excel_importer.import_file(filepath)
        if not file_data:
            return None
        print("reading %s" % filepath)
        return file_data
    
    def clean_raw_data_1(self, raw_data):
        '''
        清洗1314  1415年数据
        OrderedDict([('VT201', '2'), ('VT103', '2'), ('LossNoFeed', '0'), ('Vitex', '2'), 
        ('PercPolServ', '100'), ('Locust', '2'), ('DewHive', '2'), ('WintDecreae', '0'), 
        ('Rape', '2'), ('NumPolServ', '0'), ('OtherNectar', ''), ('Race', '3'), ('Longan', '1'), 
        ('VT106', '2'), ('VT104', '1'), ('VT012', '2'), ('Jujube', '2'), ('COL_END_APR', '140'), 
        ('Sunflower', '2'), ('SuppBInvert', '2'), ('VT101', '2'), ('VT111', '1'), ('VT202', '2'), 
        ('QCol', '2'), ('QChange', '2'), ('QProblem', '0'), ('SuppOther', ''), 
        ('ProvinceID', '460000'), ('VT_ALL', '1'), ('NumPolSerFree', '100'), ('CDS', '0'), 
        ('LossFeed', '0'), ('VT109', '1'), ('WintSold', '40'), ('Linden', '2'), ('COL_LOSS', '0'), 
        ('Comb', '30'), ('OtherRace', ''), ('VT105', '2'), ('VT107', '2'), ('Litchi', '1'), 
        ('Loquat', '2'), ('VT110', '2'), ('VT203', '2'), ('COL_INIT_APR', '130'), ('WintMerge', '0'), 
        ('VT108', '2'), ('VT112', '1'), ('VT102', '2'), ('QOp', '1'), ('QBreed', '2'), 
        ('SuppHoney', '1'), ('COL_INIT_OCT', '105'), ('WintSplit', '45'), ('SuppHFCS', '2'), 
        ('PerMoveHon', '100'), ('VT011', '2'), ('SuppBSugar', '1'), ('Qnew', '0')])
        '''
        # import pdb; pdb.set_trace()
        data = []
        print("cleaning data 1...")
        rows = sorted([int(key) for key in raw_data.keys()])
        for key in rows:
            row_value = {}
            value = raw_data.get(str(key))
            init_colony_num = value.get("COL_INIT_OCT", 0)
            loss_colony_num = value.get("COL_LOSS", 0)
            # 过滤掉无效数据
            if is_valid_data(init_colony_num, loss_colony_num) != True:
                continue
            # 添加数据处理的过程
            row_value['COL_INIT_OCT'] = init_colony_num
            row_value['COL_LOSS'] = loss_colony_num
            # 省份
            province_code = value.get("ProvinceID", 0)
            province = Province.mapping_province_code(province_code)
            value['Province'] = province
            row_value['Province'] = province
            self.province_list.add(province)
            # 蜂群大小
            apiary_size = ApiarySize.mapping_apiary_size(init_colony_num)
            value['ApiarySize'] = apiary_size
            row_value['ApiarySize'] = apiary_size
            # 蜂群种类： 西蜂。。。
            type_code = value.get("Race", 0)
            bee_type = BeeType.mapping_bee_type_by_code(str(type_code))
            value['Race'] = bee_type
            row_value['Race'] = bee_type
            # 新脾比例
            comb = value.get("Comb")
            if comb is None:
                # 不合格数据
                continue
            comb = int(comb)
            value['Comb'] = comb
            row_value['Comb'] = comb
            self.comb_list.add(comb)
            # 采用的换王方法  QCol自然更换  QOp 自己育王 QBreed 购买蜂王
            qcol = value.get('QCol')
            qop = value.get('QOp')
            qbreed = value.get('QBreed')
            change_method = {
                "col": int(qcol),
                "op": int(qop),
                "breed": int(qbreed),
            }
            value['ChangeMethod'] = change_method
            row_value['ChangeMethod'] = change_method
            
            # 换王次数
            qchange = value.get('QChange')
            if qchange is None:
                # 不合格数据
                continue
            qchange = int(qchange)
            self.qchange_num_list.add(qchange)
            value['QChange'] = qchange
            row_value['QChange'] = qchange

            # 新蜂王比例

            # 平均每群产蜜量

            # 蜜源植物
            

            # self.nectar_list.add(nectar)

            # 敌害

            # 越冬饲喂

            # 治螨


            data.append(value)

        return data


    def clean_raw_data_2(self, raw_data):
        '''
        1516  1617年数据
        读入数据
        [OrderedDict([('Province', '四川'), ('Race', ' 杂交种、卡尼鄂拉蜂'), ('COL_INIT_APR', 380), 
        ('NumPolServFree', 380), ('WinSplit', 0), ('COL_INIT_OCT', 320), ('Supply', '蜂蜜、白糖'), 
        ('PerMoveHon', 380), ('WinDecrease', 0), ('QChange', 2), ('Nectar', '油菜、 洋槐、枣花'), 
        ('COL_END_APR', 310), ('CDS', 0), ('NumPolServ', 0), ('VTXX', '2014.12，2015.6.12'), 
        ('LossFeed', 0), ('VT_ALL', '是'), ('Comb', 30), ('QSource', '自己移虫育王'), ('COL_LOSS', 20), 
        ('LossNoFeed', 0), ('QProblem', 0), ('WintMergeSold', 0)])]
        '''
        data = []
        # import pdb; pdb.set_trace()
        print("cleaning data 2...")
        rows = sorted([int(key) for key in raw_data.keys()])
        for key in rows:
            row_value = {}
            value = raw_data.get(str(key))
            init_colony_num = value.get("COL_INIT_OCT")
            col_loss = value.get("COL_LOSS")
            # 损失群里有可能有数字加文字，只取数字
            col_loss = re.search(r'\d+', str(col_loss))
            if col_loss:
                loss_colony_num = col_loss.group()
            else:
                loss_colony_num = 0
            if is_valid_data(init_colony_num, loss_colony_num) != True:
                continue
            # 添加数据处理的过程
            row_value['COL_INIT_OCT'] = init_colony_num
            row_value['COL_LOSS'] = loss_colony_num
            value['COL_LOSS'] = loss_colony_num
            # 省份
            province_input = value.get("Province", "0")
            province = Province.mapping_province_dict(province_input)
            value['Province'] = province
            row_value['Province'] = province
            self.province_list.add(province)
            # 蜂群大小
            apiary_size = ApiarySize.mapping_apiary_size(init_colony_num)
            value['ApiarySize'] = apiary_size
            row_value['ApiarySize'] = apiary_size
            # 蜂群种类： 西蜂。。。
            type_code = value.get("Race", 0)
            bee_type = BeeType.mapping_bee_type_by_str(str(type_code))
            value['Race'] = bee_type
            row_value['Race'] = bee_type
            # 新脾比例  如果表格数据为空则认为是非法数据
            comb = value.get("Comb")
            if comb is None:
                # 不合格数据
                continue
            try:
                if isinstance(comb, str):
                    if '%' in comb:
                        comb = comb[:-1]
                    elif ':' in comb:
                        comb = comb.split(":")
                        comb = int((int(comb[0])/int(comb[1]))*100)
                    elif '-' in comb:
                        # 20%-30% 的情况
                        comb_list = comb.split("-")
                        min_comb = comb_list[0][:-1]
                        max_comb = comb_list[1][:-1]
                        comb = (float(min_comb)+float(max_comb))/2
                else:
                    if comb < 1:
                        comb *= 100
                comb = int(comb)
                value['Comb'] = comb
                row_value['Comb'] = comb
                self.comb_list.add(comb)
            except:
                continue

            # 采用的换王方法  QCol自然更换  QOp 自己育王 QBreed 购买蜂王

            # 换王次数
            qchange = value.get('QChange')
            if qchange is None:
                # 不合格数据
                continue

            if isinstance(qchange, str):
                if '全部' in qchange:
                    continue
                elif '两次' in qchange:
                    qchange = 2
                elif '—' in qchange:
                    # import pdb;pdb.set_trace()
                    # 1—2次 的情况
                    qchange_list = qchange.split("—")
                    qchange = qchange_list[0]
                elif '-' in qchange:
                    # import pdb;pdb.set_trace()
                    # 1-2 的情况
                    qchange_list = qchange.split("-")
                    qchange = qchange_list[0]
                elif '次' in qchange:
                    qchange = qchange[:-1]
                elif '无' in qchange:
                    qchange = 0
                elif '~' in qchange:
                    # 1~2 的情况
                    qchange_list = qchange.split("~")
                    qchange = qchange_list[0]
           
            qchange = int(qchange)
            self.qchange_num_list.add(qchange)
            value['QChange'] = qchange
            row_value['QChange'] = qchange

            # 新蜂王比例
            
            # 平均每群产蜜量

            # 蜜源植物

            # 敌害

            # 越冬饲喂

            # 治螨
            
            data.append(value)

        return data
    def plot_apiary(data):
        small_rate = data[ApiarySize.SMALL]["rate"]
        medium_rate = data[ApiarySize.MEDIUM]["rate"]
        large_rate = data[ApiarySize.LARGE]["rate"]
        total_rate = small_rate + medium_rate + large_rate
        small_x = [ApiarySize.SMALL] * len(small_rate)
        medium_x = [ApiarySize.MEDIUM] * len(medium_rate)
        large_x = [ApiarySize.LARGE] * len(large_rate)
        total_x = small_x + medium_x + large_x
        self.plot(total_x, total_rate)

    def plot(self, x_axis, y_axis, type="scatter"):
        if type == "scatter":
            plt.scatter(x_axis, y_axis, s=200, label = '$like$', c = 'blue', marker='.', alpha = None, edgecolors= 'white')
            plt.legend()
            plt.show()


    def cal_total_loss_rate(self, total_colony_num, total_loss_num):
        loss_rate = 0
        loss_rate = self.mean_confidence_interval(list(map(lambda x,y: x/y, total_loss_num, total_colony_num)))
        return loss_rate

    def mean_confidence_interval(self, data):
        # 计算置信区间
        a = 1.0 * np.array(data)
        n = len(a)
        m, se = np.mean(a), scipy.stats.sem(a)
        h = se * scipy.stats.t.ppf((1 + self.confidence) / 2., n-1)
        return m, m-h, m+h


if __name__ == "__main__":
    # import pdb; pdb.set_trace()
    dc = DataController()
    dc.analysis()
