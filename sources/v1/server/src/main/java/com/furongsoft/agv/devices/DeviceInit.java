package com.furongsoft.agv.devices;

import com.furongsoft.agv.devices.model.ButtonBoxModel;
import com.furongsoft.agv.devices.services.CallButtonService;
import com.furongsoft.base.exceptions.BaseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * 设备初始化
 *
 * @author linyehai
 */
@Component
public class DeviceInit implements CommandLineRunner {
    private final CallButtonService callButtonService;

    @Autowired
    public DeviceInit(CallButtonService callButtonService) {
        this.callButtonService = callButtonService;
    }

    @Override
    public void run(String... args) throws BaseException {
        initDeviceManager();
    }

    /**
     * 初始化设备配置到管理器中
     */
    private void initDeviceManager() {
        List<ButtonBoxModel> buttonBoxes = callButtonService.selectButtonBoxes();
        // 将按钮添加到内存中
        DeviceManager.getInstance().addButtonBoxes(buttonBoxes);
        //
        ExecutorService pool = Executors.newFixedThreadPool(10);
//        if (!CollectionUtils.isEmpty(buttonBoxes)) {
//            buttonBoxes.forEach(buttonBoxModel -> {
//                pool.submit(new ButtonBoxRead(buttonBoxModel));
//            });
//        }
//        pool.submit(new ButtonBoxWrite());
//        pool.submit(new LightOff());

    }
}
