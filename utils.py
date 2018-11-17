# -*- coding: utf-8 -*-

def is_valid_data(origin_number, loss_number):
    # 如果loss >= origin,则为无效数据
    try:
        if int(loss_number) < int(origin_number) and int(origin_number) > 0:
            return True 
        else:
            return False
    except:
        return False
